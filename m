Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2AQACz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 19:02:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34384 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2AQACx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 19:02:53 -0500
MIME-Version: 1.0
In-Reply-To: <20120116235427.168e13f2@pyramind.ukuu.org.uk>
References: <20120109003255.GA6598@havoc.gtf.org> <CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
 <4F12E57E.3090805@garzik.org> <1326676534.13517.3.camel@minggr>
 <1326691403.13517.21.camel@minggr> <CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
 <20120116194211.2cd09fb3@pyramind.ukuu.org.uk> <CA+55aFxNcAtCmzEejS=3+_L_rp-MOBS0yLS061YgiCsFw_Mt5Q@mail.gmail.com>
 <20120116195427.64edd96f@pyramind.ukuu.org.uk> <CA+55aFzXFyHTUv=8NtSmXA2UY_qO5P=HXdGnhUmF9YoA5vpX1g@mail.gmail.com>
 <CA+55aFxUyBvkAhQZFKDuiJrMx9sR2Nb3s5F3P8wDLa4eNspJ1Q@mail.gmail.com>
 <4F14881C.8040601@garzik.org> <20120116235427.168e13f2@pyramind.ukuu.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 16:02:31 -0800
X-Google-Sender-Auth: f7ymvC98wt1pGYwn5tn96jPtuow
Message-ID: <CA+55aFyafh6cCiV=mMA6Z7qtWqBrJ_pGPev09PP14nJ8Hc=vmg@mail.gmail.com>
Subject: Re: [git patches] libata updates for 3.3
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 3:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Part of the problem with force-enable is that the MMIO BAR may need a
>> value, and not have it.  That, and an expectations mismatch between BIOS
>
> That's fine - we can happily assign one at boot time.

Actually, I think the reason that Matthews patch doesn't work for me
is that on my device, BAR #5 really is a _port_ BAR.

I didn't play with it much - busy merging and looking at various other
issues - but I'm starting to wonder whether maybe that 8086:1c01 chip
doesn't support AHCI at all. Or maybe it does something differently.

Other reports of this have BAR#5 either clear, or an MMIO BAR.   That

   Region 5: I/O ports at ffe0 [size=16]

looks really odd. Matthew's patch uses

  pci_assign_resource(pdev, 5);

but if it is a PIO region, that won't help anything..

That may be why it oopses for me - the AHCI driver is trying to use a
PIO address as an MMIO one with readl().

                   Linus
