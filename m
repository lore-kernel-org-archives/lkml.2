Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab0DIUAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:00:07 -0400
Received: from tex.lwn.net ([70.33.254.29]:58047 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab0DIUAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:00:04 -0400
Date: Fri, 9 Apr 2010 13:59:59 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 04/16] viafb: Retain GEMODE reserved bits
Message-ID: <20100409135959.381d819a@bike.lwn.net>
In-Reply-To: <4BBE99F6.9060300@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-5-git-send-email-corbet@lwn.net>
	<4BBE99F6.9060300@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 05:07:34 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> in your later patch "[PATCH 06/16] viafb: complete support for 
> VX800/VX855 accelerated framebuffer" you reintroduce initializing those 
> bits to 0. That's fine but I can't see a reason for preserving this bits 
> here as it adds useless overhead unless the hardware itself changed some 
> of those bits and behaves differently according to those bits. 

Somehow the cost of an additional MMIO read at mode setting time is
just not going to keep me up at night.

I will admit that I've learned to be rather superstitious when it comes
to messing with reserved bits.  Hardware designers like to hide
functionality like "bring down the wrath of the gods" behind such
bits.  The old code preserved them and worked, so I did the same.  I
don't see any real reason not to keep it.

> Additionally the first 2 bits are not reserved but provide a rotation 
> where 00 is what we want (no rotation).

That much is true, yes.  My mistake, will fix.

> And if you rip code off hw_bitblt_2 it would be better to do the same 
> with hw_bitblt_1. A quick look reveals that the same function can be 
> used there (the error message would need to be adjusted but that's minor).

That had crossed my mind; there is quite a bit of duplicated code
between those two very long functions.  At the time I was focused on
making things work, and I didn't want to mess with code that I couldn't
actually test.  So further cleanup is on my list, but I would prefer to
defer it for a little bit.

Thanks,

jon
