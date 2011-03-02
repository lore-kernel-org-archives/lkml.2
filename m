Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab1CBC2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 21:28:07 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:53334 "EHLO
	Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956Ab1CBC2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 21:28:06 -0500
Message-ID: <4D6DAB06.7090806@tlinx.org>
Date: Tue, 01 Mar 2011 18:27:18 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.8.1.24) Thunderbird/2.0.0.24 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Dave Chinner <david@fromorbit.com>, xfs-oss <xfs@oss.sgi.com>,
        PXXdraig Brady <P@draigBrady.com>
Subject: Re: RFE kernel option to do the desirable thing, w/regards to 'O_DIRECT' and mis-aligned data
References: <4D648D7D.7040500@tlinx.org> <4D64E2BB.7010000@draigBrady.com> <4D654C2E.2000703@tlinx.org> <20110224092625.GA3087@dastard>
In-Reply-To: <20110224092625.GA3087@dastard>
X-Stationery: 0.4.10
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    Thanks for the shorthand Dave, but I wasn't really trying to use
xfs_mkfs to make a file that was failing -- but was more trying to use
it as an example of supporting the idea that both should succeed, and
if a write is a partial write to an O_DIRECT file, that it be allowed
to succeed and the kernel, knowing the device's minimum write size
from the driver, could buffer the last sector. 

To deal with back-compat issues, it could be based off of a proc
var like /proc/kernel/fs/direct_IO_handling using bitfields (or
multiple vars if you don't like bitfields, I s
with the bits defined as:

Bit 0 Controlling allowed partial writes that start at an aligned position
Bit 1 Controlling allowed non-aligned writes
Bit 2 Controlling allowed partial reads that start at aligned position
Bit 3 Controlling allowed non-aligned reads
Bit 4 Controlling whether to use general FS cache for affected sectors

It's a bit of 'overkill' for what I wanted (just case controlled by
Bit 0), but for sake of completeness, I thought all of these combinations
should be specified.

Default of 0 = current behavior of mis-aligned data accesses failing,
while specifying various combinations would allow for variations with
the kernel handling mis-aligned accesses automatically, much like the
x86 processor handles mis-aligned integer additions or stacks automatically
(perhaps at a performance penalty, but with a tendency toward 'working'
rather than failing, if possible).

It seems better to put that logic in the kernel rather than saddle multiple
applications using DIRECT I/O with handling the non-aligned cases. 
This seems especially useful given the long term trend toward
increasing use of static-memory devices which will likely support
arbitrary direct I/O sizes. 

Linda Walsh


