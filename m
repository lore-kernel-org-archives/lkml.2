Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab2EKRZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:25:30 -0400
Received: from natasha.panasas.com ([67.152.220.90]:42469 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2EKRZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:25:28 -0400
Message-ID: <4FAD49EB.5010804@panasas.com>
Date: Fri, 11 May 2012 20:18:35 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Rob Landley <rob@landley.net>,
        Ludwig Nussel <ludwig.nussel@suse.de>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        open list:
	EXT2 FILE SYSTEM <linux-ext4@vger.kernel.org>,
        "; open list":
	DOCUMENTATION <linux-doc@vger.kernel.org>, ;
Illegal-Object: Syntax error in To: addresses found on vger.kernel.org:
	To:	;open list:DOCUMENTATION <linux-doc@vger.kernel.org>
			^-extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH RESEND] implement uid and gid mount options for ext2,
 ext3 and ext4
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.de> <20120511034945.GA15892@mobil.systemanalysen.net> <4FAD2161.3090108@landley.net> <20120511164605.GC6467@thunk.org>
In-Reply-To: <20120511164605.GC6467@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 07:46 PM, Ted Ts'o wrote:

> On Fri, May 11, 2012 at 09:25:37AM -0500, Rob Landley wrote:
>> Well it's certainly a point of view. Luckily, FAT already _has_ the
>> workaround we're discussing.  The objections were mainly "can't the VFS
>> do this for us?" and the answer, upon closer inspection, turned out to
>> be "not easily, no, the VFS takes option flags instead of parsing string
>> options so doesn't have some necessary infrastructure".
> 
> The only reasonable use case I can imagine for this feature is one
> where someone wants to use a removable storage device (which could be
> a USB thumb drive to a USB HDD to a SSD in a USB 3.0 enclosure) as an
> interchange device between Unix systems which do not have compatible
> uid/gid spaces.


How is that ext* special? You said "Unix systems" there are lots more
FSs more common to "Unix" systems

> 
> So perhaps the right approach is that we should have an ext2/3/4
> read-only feature flag which enforces a default of nosuid and all
> files to be read-only and world-readable.  There would be mount
> options which could modify this default behaviour so that the files
> could be writeable by a particular uid or gid, and another mount
> option which would change the permission bits seen for that file
> system from 0755/0644 for directories/files to 0700/0600.
> 
> Basically, the idea is we should mark the file system in an explicit
> way that it is intended for interchange across incompatible uid/gid
> spaces, with defaults which minimize security risk.  The fact that all
> files become world-readable is potentially a risk, but if the user is
> willing to put their private files on a removeable media that could
> easily be dropped in a parking lot, or otherwise stolen or lost,
> that's a potential risk that they've implicitly accepted in any case;
> we might as well make it be explicit.


They can make that explicit by formatting as vfat or ntfs, fully
interchangeable not only on "Unix".

Or by doing the proper copy when filling up the media in the
first place.

As a maintainer of ext4 filesystem which is the official system for
Linux in many distrows, still. Please resists any such crap.
User "convenience-vs-security was never a geol of Unix.

> 
> 							- Ted


Please, for your own peace of mind, in an historical perspective,
don't do this

Boaz

