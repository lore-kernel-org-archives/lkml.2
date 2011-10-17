Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab1JQRLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:11:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47567 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab1JQRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:10:59 -0400
Date: Mon, 17 Oct 2011 13:08:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] Re: [PATCH 0/3] x86/microcode: support for microcode
 update in Xen dom0
Message-ID: <20111017170854.GE19756@phenom.dumpdata.com>
References: <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
 <20111012214013.GD28723@aftab>
 <4E96198F.4030906@zytor.com>
 <20111013073352.GB501@aftab>
 <20111013095708.GA1862@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013095708.GA1862@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4E9C6132.02E6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 11:57:08AM +0200, Borislav Petkov wrote:
> On Thu, Oct 13, 2011 at 03:33:52AM -0400, Borislav Petkov wrote:
> > Bottomline is, extending initrd handling to deal with multiple initrd
> > images might turn out to be easier to do than the linked list deal.
> 
> Alternatively and IMHO, we could avoid the bootloader enabling by
> making the ucode part of the initramfs and pull up some of the
> prepare_namespace() work in kernel_init() before smp_init() so that we
> can have it ready for when bootstrapping the cores.

<scratches his head>
You are still using the microcode API (the existing one) to
program the CPUs right? It is just that you are fetching the images
much much earlier than it currently is done?

