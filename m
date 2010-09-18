Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0IRJEb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 05:04:31 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:59365 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755256Ab0IRJEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 05:04:30 -0400
Date: Sat, 18 Sep 2010 11:04:28 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org
Subject: Re: Sudden "hangs"....
Message-ID: <20100918090427.GJ31391@bitwizard.nl>
References: <20100916143304.GA14874@bitwizard.nl> <20100917164723.GA13770@animx.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917164723.GA13770@animx.eu.org>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 12:47:23PM -0400, Wakko Warner wrote:
> Rogier Wolff wrote:
> > It seems my home workstation hangs on a "mkdir" once every morning for
> > about half a minute. It'll freeze whatever I'm doing and continue
> > happily 30 seconds later, but I can't figure out what's going on
> > because it's frozen...
> 
> One of my volumes was doing this.  As someone mentioned earlier, check your
> kernel log to see if you have a disk error.

I work at "harddisk-recovery.nl". I know how to recognize bad disks. You can
recognize a bad block in the vmstat output in that the bi and bo numbers
go to zero for at least 10 seconds. This doesn't happen, as you can see
in the original post. 

> On mine, I had no errors.  The activity led for that volume would be
> on solid until the mkdir completed. 

Besides that I can't see the activity led from my chair. But vmstat shows
that it would be solid indeed. 

> My fix was to create a new
> directory and move everything over and remove the old directory.
> Obviously this won't work if you're having problems with more than 1
> directory or the offending directory is the root of the volume.

This helps for the "very big directory" case. Directories are never
shrunk. So if a directory has become very large because of thousands
of files at one point in time, you can reduce that with the move-all-files
trick. 

When it happened and I recognized the effect, I typed the "time mkdir"
command. I just chose the root of the partition for this. The directory
there is NOT large: 

drwxrwsr-x 32 root hdr 4096 2010-09-17 22:05 .

In fact it is as small as possible. 

IMHO, the hint is that the flush process for the device ends up in
top. Now if I understand the word "flush" correctly I'd expect it to
write dirty buffers to the device. In this case, vmstat however
reports mostly data coming INTO the computer. So why would the flush
process need to READ data from the device?



	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
