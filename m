Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab1A0DxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 22:53:20 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:6893 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753367Ab1A0DxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 22:53:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAOp6QE1Ld/sX/2dsb2JhbAAMhAjMc5BogSODOHQEhRg
X-IronPort-AV: E=Sophos;i="4.60,384,1291611600"; 
   d="scan'208";a="89378518"
Message-ID: <4D40EC2D.5020507@teksavvy.com>
Date: Wed, 26 Jan 2011 22:53:17 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <4D40CDCF.4010301@teksavvy.com> <20110127034314.GI21311@dastard>
In-Reply-To: <20110127034314.GI21311@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 10:43 PM, Dave Chinner wrote:
> On Wed, Jan 26, 2011 at 08:43:43PM -0500, Mark Lord wrote:
>> On 11-01-26 08:22 PM, Mark Lord wrote:
..
>> Thinking about it some more:  the first problem very much appears as if
>> it is due to a filesystem check happening on the already-mounted filesystem,
>> if that makes any kind of sense (?).
> 
> Not to me.  You can check this simply by looking at the output of
> top while the problem is occurring...

Top doesn't show anything interesting, since disk I/O uses practically zero CPU.

>> running xfs_check on the umounted drive takes about the same 30-60 seconds,
>> with the disk activity light fully "on".
> 
> Well, yeah - XFS check reads all the metadata in the filesystem, so
> of course it's going to thrash your disk when it is run. The fact it
> takes the same length of time as whatever problem you are having is
> likely to be coincidental.

I find it interesting that the mount takes zero-time,
as if it never actually reads much from the filesystem.
Something has to eventually read the metadata etc.

>> The other thought that came to mind:  this behaviour has only been
>> noticed recently, probably because I have recently added about
>> 1000 new files (hundreds of MB each) to the videos/ directory on
>> that filesystem.  Whereas before, it had fewer than 500 (multi-GB)
>> files in total.
>>
>> So if it really is doing some kind of internal filesystem check,
>> then the time required has only recently become 3X larger than
>> before.. so the behaviour may not be new/recent, but now is very
>> noticeable.
> 
> Where does that 3x figure come from?

Well, it used to have about 500 files/subdirs on it,
and now it has somewhat over 1500 files/subdirs.
That's a ballpark estimate of 3X the amount of meta data.

All of these files are at least large (hundreds of MB),
and a lot are huge (many GB) in size.

Cheers
