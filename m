Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab1EWS4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:56:09 -0400
Received: from mail.avalus.com ([89.16.176.221]:41637 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1EWS4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:56:07 -0400
Date: Mon, 23 May 2011 19:56:03 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Ts'o" <tytso@mit.edu>, Alex Bligh <alex@alex.org.uk>
Subject: Re: BUG: Failure to send REQ_FLUSH on unmount on ext3, ext4, and FS
 in general
Message-ID: <A0F77BF1A64FB25344FC4021@Ximines.local>
In-Reply-To: <20110523173350.GA10554@infradead.org>
References: <959E4E25EAEC544D31199E6F@nimrod.local>
 <20110523155550.GE4716@quack.suse.cz>
 <EC63F9E077B362A0FDCF3527@Ximines.local>
 <20110523172906.GH4716@quack.suse.cz> <20110523173350.GA10554@infradead.org>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--On 23 May 2011 13:33:50 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> It really should be changed.  The previous (bad) excuse was that the
> ordering barrier code was too much overhead.  Making a filesystem
> non-safe by default is already a bad sin, but having the code to make
> it safe around and not enabling it is plain criminal.

At risk of wandering into ext3 default flamewar, I suppose people foolishly
or not might want to live dangerously. If I'm creating an image on a
loopback mount, or copying stuff to a removable harddrive, perhaps I don't
really care if data gets corrupted if the power drops while I am writing,
as I can recreate the data. I'm always going to have that issue even with
FAT32 and other dinosaurs (ext2). I *do*, however, care if unmount()
doesn't write all the data, especially as "sync; sync; sync" doesn't
appear to write the data either.

-- 
Alex Bligh
