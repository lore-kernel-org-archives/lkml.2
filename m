Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0L1Oib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:38:31 -0500
Received: from thunk.org ([69.25.196.29]:35377 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242Ab0L1OiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:38:12 -0500
Date: Tue, 28 Dec 2010 09:15:16 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Rogier Wolff <R.E.Wolff@bitwizard.nl>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Regular ext4 error warning with HD in USB dock
Message-ID: <20101228141516.GH10149@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Rogier Wolff <R.E.Wolff@bitwizard.nl>,
	Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org>
 <20101228081917.GA1351@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228081917.GA1351@bitwizard.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 09:19:17AM +0100, Rogier Wolff wrote:
> > That's actually not an error.  It's a report which is generated every
> > 24 hours, indicating that there has been 3 errors since the last time
> > the error count has been cleared, with the first error taking place at
> > Sat Nov 6 10:27:57 2010 (US/Eastern) in the function
> > ext4_journal_start_sb(), at line 251, and the most recent error taking
> > place at Sat Nov 6 18:02:28 2010 (US/Eastern), in the function
> > ext4_put_super() at line 719.  This is a new feature which was added
> > in 2.6.36.
> 
> Nice. But the issue you're not mentioning is: What errors could have 
> happened on the 6th of november? Should Con worry about those errors?

It looks like those errors were probably caused by I/O errors while
writing to the journal.  Maybe due to a flakey USB connection,
perhaps?  It would be useful to look at the /var/log/messagfes around
that date to get a more detailed look.

> OK, the chances are that he has rebooted since november, and that an
> older fsck fixed the errors, but not cleared the "fs errror log". Would
> these errors have triggered a "remount-readonly" if the fs was mounted 
> like that?

Yes, errors that get recorded into the superblock are also errors that
would cause a read-only remount if the file system is set that way.

      	      			       	    - Ted
