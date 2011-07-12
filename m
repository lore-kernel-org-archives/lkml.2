Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1GLWca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:32:30 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:40482 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab1GLWc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:32:28 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com AA956B41F2
Date: Wed, 13 Jul 2011 00:22:27 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/2] fadvise: support POSIX_FADV_NOREUSE
Message-ID: <20110712222227.GA1316@thinkpad>
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com>
 <4E07F349.2040900@jp.fujitsu.com>
 <20110627071139.GC1247@thinkpad>
 <4E0858CF.6070808@draigBrady.com>
 <20110627102933.GA1282@thinkpad>
 <4E086F51.50403@draigBrady.com>
 <8762n7kvym.fsf@cmungerjr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762n7kvym.fsf@cmungerjr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 02:52:49PM -0700, Patrick J. LoPresti wrote:
> 
> > IIUC, NOREUSE means "the application will use this range of the file
> > once". It's something that we do _before_ accessing the file.  And the
> > kernel needs to remember the ranges of NOREUSE data for each file, so
> > that page cache can be immediately dropped after the data has been
> > accessed (if possible).
> 
> I am no expert on the Linux page cache, but my applications have a great
> interest in exercising some control over it...
> 
> Could NOREUSE be as simple as setting a bit on the page that means
> "never mark this page active"?
> 
> Or more conservatively, "clear this bit before marking the page active"?
> 
> So POSIX_FADV_NOREUSE would set the bit on the page.  Then any operation
> that would normally mark the page active would instead merely clear the
> bit.  This would keep the page on the inactive list _after_ the first
> read and allow it to be reclaimed, which is at least in the "spirit" of
> NOREUSE.

If the file data is not in memory you can't set a bit in any struct
page. You could even open a file and execute POSIX_FADV_NOREUSE without
reading any page from the file.

I think it would be better to maintain a list of file offset/length
structures per file descriptor or (as a starting solution) even mark the
entire file as non-cacheable without considering the ranges.

-Andrea
