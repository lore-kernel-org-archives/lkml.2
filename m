Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab0KYSEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:04:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab0KYSEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:04:02 -0500
Date: Thu, 25 Nov 2010 13:04:00 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Len Brown <lenb@kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [RFT][PATCH] Poke ACPI about connected floppy drives
Message-ID: <20101125180400.GI22651@bombadil.infradead.org>
References: <20101122182428.GR22651@bombadil.infradead.org>
 <alpine.LFD.2.00.1011242153330.637@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011242153330.637@x980>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:57:22PM -0500, Len Brown wrote:
> I have 45 DSDTs on-hand that include PNP0700,
> but only 18 of those implement _FDE...
> 

Awesome, thanks for testing. Poking people to test the module on their
machines I saw pretty much the same experiences. A lot of tables that
do have _FDE seem to wire it to One if there's a floppy controller,
regardless of whether a drive is wired.

Pretty much makes it useless for what I was hoping to use it for
(avoiding probing floppies on machines without them attached, since it
 sometimes takes quite a while.)

> I have a Lenovo T61 which has PNP0700 and implements _FDE.
> However, it doesn't physically have a floppy, and so
> acpi_fde_add() will never get called -- I guess
> because _CRS said it wasn't present?  This seems
> to make evaluating _FDE from the .add routine
> somewhat redundant, no?
> 

I'm not sure what _CRS is, so I don't know. :/ I'll look it up.

> Note that you've got a memory leak in acpi_fde_add()
> in the "if (!c)" case.  Also, "rmmod floppy" takes an oops.
> 

Oops, sorry, it was just for testing so I didn't bother checking those.

Not sure the patch is worth the effort given how few DSDTs implement
_FDE though.

regards, Kyle

> cheers,
> Len Brown, Intel Open Source Technology Center
> 
