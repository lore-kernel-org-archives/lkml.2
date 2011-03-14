Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1CNQhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 12:37:46 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:34261 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1CNQhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 12:37:45 -0400
Date: Mon, 14 Mar 2011 11:37:42 -0500
From: scameron@beardog.cce.hp.com
To: Jens Axboe <axboe@kernel.dk>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com,
        scameron@beardog.cce.hp.com
Subject: Re: [PATCH 0/7] cciss: updates as of March 11, 2011
Message-ID: <20110314163742.GA3742@beardog.cce.hp.com>
References: <20110311205306.2211.53569.stgit@beardog.cce.hp.com> <4D7B36E6.2050702@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7B36E6.2050702@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 12, 2011 at 10:03:34AM +0100, Jens Axboe wrote:
> On 2011-03-11 21:55, Stephen M. Cameron wrote:
> > The following series is vs. Jens Axboe's for-2.6.39/drivers branch. 
> > 
> > ---
> > 
> > Stephen M. Cameron (7):
> >       cciss: hoist tag masking out of loop
> >       cciss: Inform controller we are using 32-bit tags.
> >       cciss: Mask off error bits of c->busaddr in cmd_special_free when calling pci_free_consistent
> >       cciss: remove unnecessary casts
> >       cciss: fix missed command status value CMD_UNABORTABLE
> >       cciss: add cciss_tape_cmds module paramter
> >       cciss: export resettable host attribute
> 
> I have applied 1-5/7, 6 and 7 do not apply. Please check
> for-2.6.39/drivers and check and resend those last two patches.

Ok, I am confused.  Maybe I'm doing something wrong, but
I can't quite spot what it is.

Does this look right?

[scameron@localhost linux-2.6]$ git remote update
Fetching origin
Fetching james
Fetching jens
[scameron@localhost linux-2.6]$ git checkout -b hp-cciss-2011-03-14 jens/for-2.6.39/drivers 
Branch hp-cciss-2011-03-14 set up to track remote branch for-2.6.39/drivers from jens.
Switched to a new branch 'hp-cciss-2011-03-14'

Now I try to apply the patch 6, which I downloadeded from here:
http://marc.info/?l=linux-kernel&m=129987702317844&q=raw
(that is, the same one I mailed out on Friday, which I had to do because stg
has a bug that it won't honor CC to yourself):

[scameron@localhost linux-2.6]$ patch -p1 --dry-run < /tmp/cciss-add-cciss_tape_cmds-module-parameter.patch 
patching file Documentation/blockdev/cciss.txt
patching file drivers/block/cciss.c
Hunk #2 succeeded at 4116 (offset 39 lines).
Hunk #3 succeeded at 4631 (offset 39 lines).
patching file drivers/block/cciss_scsi.c
patching file drivers/block/cciss_scsi.h
patch unexpectedly ends in middle of line

Ok... that's weird.

Well, if I delete this bit at the end (which was not put there by me) which says:
  --
  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
  the body of a message to majordomo@vger.kernel.org
  More majordomo info at  http://vger.kernel.org/majordomo-info.html
  Please read the FAQ at  http://www.tux.org/lkml/

then it does seem to apply...
 
[scameron@localhost linux-2.6]$ patch -p1 --dry-run < /tmp/cciss-add-cciss_tape_cmds-module-parameter.patch 
patching file Documentation/blockdev/cciss.txt
patching file drivers/block/cciss.c
Hunk #2 succeeded at 4116 (offset 39 lines).
Hunk #3 succeeded at 4631 (offset 39 lines).
patching file drivers/block/cciss_scsi.c
patching file drivers/block/cciss_scsi.h
[scameron@localhost linux-2.6]$

And compiles too...

[scameron@localhost linux-2.6]$ make SUBDIRS=drivers/block modules
  CC [M]  drivers/block/floppy.o
  CC [M]  drivers/block/cciss.o
  CC [M]  drivers/block/pktcdvd.o
...

So not sure why it doesn't apply for you, unless somehow I'm not checking
out your git tree in the right way.

And then git log is showing patch 7 is applied after all?

commit 957c2ec558caff09a3bdf333871fc617830f063d
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Fri Mar 11 20:06:09 2011 +0100

    cciss: export resettable host attribute

    This attribute, requested by Redhat, allows kexec-tools to know
    whether the controller can honor the reset_devices kernel parameter
    and actually reset the controller.  For kdump to work properly it
    is necessary that the reset_devices parameter be honored.  This
    attribute enables kexec-tools to warn the user if they attempt to
    designate a non-resettable controller as the dump device.

    Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

Maybe you hand applied it?

-- steve

