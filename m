Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1FCSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:41:17 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:47196
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753935Ab1FCSlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:41:16 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE92AC0.1000806@freescale.com>
Date: Fri, 3 Jun 2011 13:41:04 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
References: <1307119552-15573-1-git-send-email-timur@freescale.com>	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>	<4DE92675.6080908@freescale.com>	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>	<4DE9294B.3040501@freescale.com> <BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
In-Reply-To: <BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> The point is data should cross kernelspace/userspace boundary only once.

And my new version does that.  I'm just asking if you're okay with it.

Let me repost the whole function:

char *strdup_from_user(const char __user *ustr, size_t max)
{
	size_t len;
	char *str;

	str = kzalloc(max, GFP_KERNEL);
	if (!str)
		return ERR_PTR(-ENOMEM);

	if (copy_from_user(str, ustr, max - 1)) {
		kfree(str);
		return ERR_PTR(-EFAULT);
	}

	return krealloc(str, strlen(str) + 1, GFP_KERNEL);
}


-- 
Timur Tabi
Linux kernel developer at Freescale

