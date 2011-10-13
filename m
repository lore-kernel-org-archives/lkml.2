Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1JMHeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:34:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42287 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1JMHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:34:05 -0400
Date: Thu, 13 Oct 2011 09:33:52 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
Message-ID: <20111013073352.GB501@aftab>
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com>
 <4E94E1E5.4070505@goop.org>
 <20111012101615.GA14966@aftab>
 <4E95D9E7.6090304@zytor.com>
 <4E95E7FE.6050302@goop.org>
 <20111012194543.GD14966@aftab>
 <20111012204048.GA22260@phenom.oracle.com>
 <4E960746.90805@zytor.com>
 <20111012214013.GD28723@aftab>
 <4E96198F.4030906@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E96198F.4030906@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 06:49:51PM -0400, H. Peter Anvin wrote:
> The stickiest part of all of this is where to leave the microcode so the 
> kernel can get to it way early.  We could use the linked list, but that 
> would mean bootloader enabling;

Yep, started looking at that and it means grub legacy and grub2 enabling
at least.

> another idea was to stick it as a prefix 
> to the initramfs identified by a signature.

https://bugzilla.redhat.com/show_bug.cgi?id=179127

with the patch there you can do

initrd /initramfs-image1.gz /initramfs-image2.gz

which is exactly what we want.

Bottomline is, extending initrd handling to deal with multiple initrd
images might turn out to be easier to do than the linked list deal.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
