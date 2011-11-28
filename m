Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab1K1OqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:46:01 -0500
Received: from casper.infradead.org ([85.118.1.10]:55430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1K1OqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:46:00 -0500
Message-ID: <4ED39EA5.4000706@kernel.dk>
Date: Mon, 28 Nov 2011 15:45:57 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Martin Steigerwald <ms@teamix.de>
CC: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: CFQ I/O priorities only for reads?
References: <201111281542.22258.ms@teamix.de>
In-Reply-To: <201111281542.22258.ms@teamix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-28 15:42, Martin Steigerwald wrote:
> Hi jens und Vivek,
> 
> Vivek, I cc'd you, cause you wrote the new cfq-iosched.txt.
> 
> 
> In trying to understand how I/O priorities actually really work, I tried to dd 
> with
> 
> rm nullen-id ; sync ; /usr/bin/time ionice -c3 dd if=/dev/zero of=nullen-id 
> count=500 bs=1M conv=fsync
> 
> versus
> 
> rm nullen-rl; sync ; /usr/bin/time ionice -c1 -n0 dd if=/dev/zero of=nullen-rl 
> count=500 bs=1M conv=fsync
> 
> concurrently. No differences. At first I was puzzled, then I thought maybe 
> direct I/O makes a difference. So I tried with oflag=direct.
> 
> And it does.
> 
> Then I actually read the documentation block/ioprio.txt (3.1 here):
> 
>> With the introduction of cfq v3 (aka cfq-ts or time sliced cfq), basic io
>> priorities are supported for reads on files.  This enables users to io nice
>> processes or process groups, similar to what has been possible with cpu
>> scheduling for ages.  This document mainly details the current
>> possibilities with cfq; other io schedulers do not support io priorities
>> thus far.
> 
> According to it I/O priorities will even only work on reads. Is that correct? 
> I mean they do work on reads, I tested it, but *only* on reads?
> 
> From what I see here, it also works for direct I/O write requests
> 
> So from what I conclude is that CFQ I/O priorities work for all requests that 
> are issued via synchronous system calls, but not for those issued via 
> asynchronous calls, i. e. everything that goes through the pagecache.
> 
> Is that correct?

Priorities work for reads AND direct writes. In other words, it does not
work for buffered writes.

> Vivek, one thing on cfq-iosched.txt: Could slice_idle=0 make sense on
> SSDs?  Later on you write that there are some SSD optimizations in
> place that cut down idling already.

It will have a functional difference even on SSDs, depending on your
workload, even if the scope of idling is smaller on an SSD.

-- 
Jens Axboe

