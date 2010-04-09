Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0DIUSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:18:39 -0400
Received: from tex.lwn.net ([70.33.254.29]:44233 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0DIUSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:18:37 -0400
Date: Fri, 9 Apr 2010 14:18:34 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 06/16] viafb: complete support for VX800/VX855
 accelerated framebuffer
Message-ID: <20100409141834.4e45f18d@bike.lwn.net>
In-Reply-To: <4BBEAB3E.5090709@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-7-git-send-email-corbet@lwn.net>
	<4BBEAB3E.5090709@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 06:21:18 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> > +	for (i = 0; i <= highest_reg; i+= 4)
> > +		writel(0x0, engine + i);
> > +
> 
> this obsoletes
> 	/* Init 2D engine reg to reset 2D engine */
> 	writel(0x0, engine + VIA_REG_KEYCONTROL);
> as VIA_REG_KEYCONTROL is 0x02C.

Ah, good point, the separate write is superfluous.  Removed.


[...]
> > +#define VIA_REG_MONOPATBGC_M1   0x05C       /* Add FG color of Pattern. */
> > +#define VIA_REG_COLORPAT_M1     0x100       /* from 0x100 to 0x1ff */
> > +
> 
> All of these defines are unused. I admit that it is my fault. I've not 
> yet found a way I like to use them as the meaning of the same hardware 
> address changed. I think the most clean long term solution would be to 
> put the engines in separate files and the definitions in private headers 
> to at least avoid the need to decode the engine version in the name.
> However as the old headers already contain a bunch of trash feel free to 
> ignore this issue and add it for now.

Harald's initial patch included a mechanism for remapping register writes
on the fly depending on which engine was in use; these defines were used
for that purpose.  Your reworking of the 2D code obliterated that patch,
and made it mostly unnecessary.  I kept the defines around, though, because
I thought that documenting the registers can only be a good thing.

Thanks,

jon
