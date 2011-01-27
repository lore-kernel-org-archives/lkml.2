Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1A0UYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:24:13 -0500
Received: from [216.187.52.7] ([216.187.52.7]:59202 "EHLO mycroft.westnet.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab1A0UYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:24:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19777.54393.645313.900155@quad.stoffel.home>
Date: Thu, 27 Jan 2011 15:24:25 -0500
From: "John Stoffel" <john@stoffel.org>
To: Mark Lord <kernel@teksavvy.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Stan Hoeppner <stan@hardwarefreak.com>,
        Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alex Elder <aelder@sgi.com>
Subject: Re: xfs: very slow after mount, very slow at umount
In-Reply-To: <4D419765.4070805@teksavvy.com>
References: <4D40C8D1.8090202@teksavvy.com>
	<20110127033011.GH21311@dastard>
	<4D40EB2F.2050809@teksavvy.com>
	<4D418B57.1000501@teksavvy.com>
	<alpine.DEB.2.00.1101271040000.31246@p34.internal.lan>
	<4D419765.4070805@teksavvy.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mark" == Mark Lord <kernel@teksavvy.com> writes:

Mark> On 11-01-27 10:40 AM, Justin Piszcz wrote:
>> 
>> 
>> On Thu, 27 Jan 2011, Mark Lord wrote:
Mark> ..
>>> Can you recommend a good set of mkfs.xfs parameters to suit the characteristics
>>> of this system?  Eg. Only a few thousand active inodes, and nearly all files are
>>> in the 600MB -> 20GB size range.  The usage pattern it must handle is up to
>>> six concurrent streaming writes at the same time as up to three streaming reads,
>>> with no significant delays permitted on the reads.
>>> 
>>> That's the kind of workload that I find XFS handles nicely,
>>> and EXT4 has given me trouble with in the past.
Mark> ..
>> I did a load of benchmarks a long time ago testing every mkfs.xfs option there
>> was, and I found that most of the time (if not all), the defaults were the best.
Mark> ..

Mark> I am concerned with fragmentation on the very special workload
Mark> in this case.  I'd really like the 20GB files, written over a
Mark> 1-2 hour period, to consist of a very few very large extents, as
Mark> much as possible.

Mark> Rather than hundreds or thousands of "tiny" MB sized extents.  I
Mark> wonder what the best mkfs.xfs parameters might be to encourage
Mark> that?

Hmmm, should the application be pre-allocating the disk space then, so
that the writes get into nice large extents automatically?  Isn't this
what the fallocate() system call is for?  Doesn't MythTV use this?

I don't use XFS, or MythTV, but I like keeping track of this stuff.

John
