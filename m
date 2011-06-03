Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1FCSyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:54:45 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:22513 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1FCSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:54:44 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE92DF1.4090203@freescale.com>
Date: Fri, 3 Jun 2011 13:54:41 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: <alan@lxorguk.ukuu.org.uk>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
References: <1307119552-15573-1-git-send-email-timur@freescale.com>	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>	<4DE92675.6080908@freescale.com>	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>	<4DE9294B.3040501@freescale.com>	<BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>	<4DE92AC0.1000806@freescale.com> <BANLkTik_O2QvXqeY03NU3xP1q0=Dqco6Eg@mail.gmail.com>
In-Reply-To: <BANLkTik_O2QvXqeY03NU3xP1q0=Dqco6Eg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> It leaks first allocation if second one fails.
> 
> Come on.

Ugh, sorry.  In my defense, I am suffering from allergies at the moment.

> Show you user in driver, maybe what we're discussing is moot.

The driver and discussion on it can be found here:

http://patchwork.ozlabs.org/patch/98233/

Search for "ioctl_dtprop" to see its usage.

In summary, I'm copying a user-space string into a kmalloc'd buffer so that it's
physically contiguous and I can get the physical address for it.  I then call
our hypervisor and give it the physical address.  This is why I want a copy of
the string in a buffer allocated via kmalloc.

-- 
Timur Tabi
Linux kernel developer at Freescale

