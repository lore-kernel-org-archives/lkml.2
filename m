Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab1HYSCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:02:10 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17460 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755125Ab1HYSCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:02:06 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4E568E19.405@freescale.com>
Date: Thu, 25 Aug 2011 13:02:01 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] tty/powerpc: fix build break with ehv_bytechan.c on allyesconfig
References: <1314289245-14946-1-git-send-email-timur@freescale.com> <20110825163234.GA31629@kroah.com>
In-Reply-To: <20110825163234.GA31629@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> tested doesn't mean that it shouldn't still build properly for other
> platforms, right?

The problem is the dependency on MSR_GS, which is defined only for Book-E
PowerPC chips, not all PowerPC.

So I gave it some more thought, and technically ePAPR extends beyond Book-E, so
it's wrong for the driver to depend on anything specific to Book-E.  I've
removed the code that breaks:

	/* Check if we're running as a guest of a hypervisor */
	if (!(mfmsr() & MSR_GS))
		return;

> What is keeping the driver from building on all PPC, or even all arches
> today?

I've made a few changes, and it builds on all PPC now.  I'll post a new patch.

-- 
Timur Tabi
Linux kernel developer at Freescale

