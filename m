Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab0L1OiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:38:14 -0500
Received: from thunk.org ([69.25.196.29]:35379 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab0L1OiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:38:12 -0500
Date: Tue, 28 Dec 2010 09:32:55 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: torn5 <torn5@shiftmail.org>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Regular ext4 error warning with HD in USB dock
Message-ID: <20101228143255.GI10149@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, torn5 <torn5@shiftmail.org>,
	Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	linux-usb@vger.kernel.org
References: <201012280953.46149.kernel@kolivas.org>
 <20101228025343.GD10149@thunk.org>
 <4D19BEF1.9010708@shiftmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D19BEF1.9010708@shiftmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 11:41:53AM +0100, torn5 wrote:
> 
> This is going to be a faq...
> I suppose the datetime is encoded (what format is that?) in that
> long number after "at".

Number of seconds since January 1st, 1970 midnight GMT.  (Standard
Unix-time format).  It's hard for the kernel to decode it since it
doesn't know what time-zone you are in, or what your local legislature
has done vis-a-vis arbitrary and cabritious adjustments to the
start/stop date of daylight savings time, etc.

It's easy enough to decode it using perl:

   perl -e '$t = localtime(1289053677); print "$t\n"'

> May I suggest the datetime gets decoded in the printing?
> Also may I suggest that the error happens immediately after mount
> and not after 300 seconds from mount?

Hmmm.... maybe.  The idea behind the 300 second delay was for the root
file system, to let e2fsck have a chance to fix the file system before
reporting the errors at mount time.

						- Ted


     	     	       
