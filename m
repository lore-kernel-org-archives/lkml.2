Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab2DBOAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:00:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39417 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:00:08 -0400
Date: Mon, 2 Apr 2012 15:59:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 00/13] Convert EDAC internal strutures to support all
 types of Memory Controllers
Message-ID: <20120402135959.GC24238@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 01:45:33PM -0300, Mauro Carvalho Chehab wrote:
> This is the 12th and final rebase of this patch series.
> 
> It is the first patchset for the EDAC rewrite. On this patchset,
> there are all the internal changes at the EDAC core, needed
> to properly represent memories at modern memory controllers that
> aren't oriented per rank/channel.
> 
> It is needed in order to fix a long-term bug at the EDAC drivers
> for the Intel memory controllers deployed since 2005 (well, in fact,
> there is one Rambus that it is older, but also suffers from the same
> syndrome), including the drivers for the recent Intel Nehalem and
> Sandy Bridge architectures.
> 
> The new EDAC architecture supports both per rank/channel memory
> controllers and per-DIMM ones.
> 
> On this changeset, there are no changes at the sysfs nodes. Just 
> like before this changeset, non-per-rank memory controllers 
> will expose memories as "virtual csrows/virtual channels[1].
> 
> [1] It sounds better to say "virtual" than to admit that all
> EDAC Intel drivers since 2005 need to lie about their age to
> the EDAC core, in order for the Kernel to accept them ;)
> 
> Mauro Carvalho Chehab (13):
>   edac: Create a dimm struct and move the labels into it
>   edac: move dimm properties to struct memset_info
>   edac: Don't initialize csrow's first_page & friends when not needed
>   edac: move nr_pages to dimm struct
>   edac: Fix core support for MC's that see DIMMS instead of ranks

I was wondering why 6/13 doesn't apply cleanly but there's the patch
above, 5/13 missing in the submission. It looks like vger has eaten it
at least for the linux-edac mailing list - the patch is still on lkml
though.

And what a patch it is: almost 5000 lines.

Please split it!

And don't tell me it cannot be done: each patch needs to do one thing
and one thing only. From looking at this monster, here's one possible
way to split it:

* add all changes to include/linux/edac.h
* a bunch of changes to edac_mc.c like edac_align_ptr etc
* changes to edac_mc_alloc
* add edac_mc_handle_error
* switch old edac_mc_handle* stuff to edac_mc_handle_error
...<a bunch more>

This way the code will be much easier to review.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
