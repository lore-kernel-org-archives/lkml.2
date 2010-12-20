Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab0LTGSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 01:18:17 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:47500 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753168Ab0LTGSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 01:18:17 -0500
Message-ID: <4D0EF4FA.30703@lougher.demon.co.uk>
Date: Mon, 20 Dec 2010 06:17:30 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>, Lasse Collin <lasse.collin@tukaani.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Squashfs: add XZ compression support
References: <4D0071C3.3070500@lougher.demon.co.uk> <20101210185214.GA10263@wolff.to>
In-Reply-To: <20101210185214.GA10263@wolff.to>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Wolff III wrote:
> On Thu, Dec 09, 2010 at 06:05:55 +0000,
>   Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
>> XZ support has (obviously) also been added to the squashfs tools (Mksquashfs
>> & Unsquashfs).  These changes are available from the Squashfs CVS repository
>> (http://sourceforge.net/projects/squashfs/develop).
> 
> Do you have an estimate for when you will make a release with these changes
> and what will likely be the version number? I want to see if it makes sense
> to start tracking the development version for F15 or F16 and what to use
> for the version.
>

Hmm, I don't know when F15 or F16 is destined to appear! (I guess roughly
3 to 6 months minimum time but correct me if I'm wrong).

Lasse collin's comment re: dictionary sizes threw a spanner in the works
so to speak as I realised my current patches don't allow users to specify
the dictionary size, which appears rather useful judging by Lasse's
comments that a dictionary size of 50% of block size only impacts
compression by 1%.  This makes it rather obvious that allowing users to
specify dictionary size in addition to block size is extremely desirable.

The rather unfortunate issue is that the current Squashfs file format
doesn't allow compressor specific options to be stored, for example it
allows compression type (i.e. gzip, lzma, lzo etc) to be stored, but there
is nowhere to store a dictionary size.

So, this has led to a week of thinking about how to add compressor
specific options to the Squashfs file format which is 100% compatible with
pre-existing 4.0 file systems and file system code.  I have settled on an
extension which is 100% compatible and which fits in well with the file
format (i.e. it is not a hack).

What does this mean in relation to your questions?  Well basically it means
in a week's time or before I'll be in a position to respin the kernel
patches to include compressor specific options support (i.e. dictionary size),
and there will be the corresponding CVS changes for the Squashfs tools.

As far as I'm concerned this makes a good point to make a new Squashfs tools
release (very few people trust the CVS versions in my experience and always
go for the last released version).  I'll probably wait for a couple of weeks
just in case CVS downloaders find any bugs (in practice I hardly ever get any
bug reports from the CVS version).  This means a Squashfs tools 4.2
release mid January.   How does this fit in with the release schedules for
F15 and F16?

Phillip
