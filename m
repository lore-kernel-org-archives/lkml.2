Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab1ACOWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 09:22:14 -0500
Received: from THUNK.ORG ([69.25.196.29]:44501 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab1ACOWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 09:22:13 -0500
Date: Mon, 3 Jan 2011 09:22:10 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Tom Watson <tsw@johana.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Offset into block file for mounting?
Message-ID: <20110103142210.GC6024@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Tom Watson <tsw@johana.com>,
	linux-kernel@vger.kernel.org
References: <1294060384.3030.18.camel@xytar7a>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294060384.3030.18.camel@xytar7a>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 05:13:04AM -0800, Tom Watson wrote:
> Hi...
> 
> I recently got a "floppy drive emulator" that uses an USB thumb drive to
> emulate floppy images to be used as a floppy drive.  In trying out the
> software (it is a bit cryptic), I found that this model stores the
> floppy images consecutively on said thumb drive (with some padding to
> make the drives on 1.5 Mbyte borders on the thumb drive.  When plugging
> in the thumb drive, the 'vfat' module just mounts the first image (as I
> expect).  What I would like to do is mount some of the other images that
> exist (I dumped out the raw thumb drive).  I believe that a simple way
> to do this is to add an offset to the vfat mount, so that the accesses
> begin at (as in my example) 0x180000 (and multiples thereof) from the
> start of the physical drive.
> 
> Is there any way to add such an offset?

Probably the easist way to solve this is to use devicemapper.  You can
use dmsetup[1] to create a device mapper volume that starts and ends at
the appropriate offsets.  You can then mount the device mapper volume
using anyu file system without having to hack in a offset mount
option.

[1] See the dmsetup man page for more details.


    			       	   - Ted
