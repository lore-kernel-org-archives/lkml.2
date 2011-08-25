Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1HYSvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:51:36 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:27748
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755273Ab1HYSvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:51:35 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E5699A8.1070708@freescale.com>
Date: Thu, 25 Aug 2011 13:51:20 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] tty/powerpc: fix build break with ehv_bytechan.c on allyesconfig
References: <1314289245-14946-1-git-send-email-timur@freescale.com> <20110825163234.GA31629@kroah.com> <4E568E19.405@freescale.com> <20110825184655.GB1891@kroah.com>
In-Reply-To: <20110825184655.GB1891@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> But don't you really want this type of check at runtime?  What happens
> if you load this driver on a machine that is not a guest?  Will things
> break?  Shouldn't you still refuse to load somehow?

This is in the udbg code, which falls under the category of, "turn this on only
if you know what you're doing."

The udbg code runs very early, before the device tree is available.  There's no
way of knowing at this point whether or not we're running under a hypervisor.
If you turn on udbg support, then it means that you're trying to do some very
specific debugging on a specific platform.

So I'm not removing this code just to fix the build break.  It really should
never have been there in the first place.

-- 
Timur Tabi
Linux kernel developer at Freescale

