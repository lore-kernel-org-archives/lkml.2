Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab2DJS4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 14:56:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38621 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab2DJS4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 14:56:23 -0400
Message-ID: <4F848253.6060303@kernel.dk>
Date: Tue, 10 Apr 2012 20:56:19 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except
 SATA
References: <20120410133708.GE21801@redhat.com> <4F843C17.5050004@kernel.dk> <20120410142148.GG21801@redhat.com> <20120410151042.GH21801@redhat.com> <4F847EC4.7040604@kernel.dk> <20120410185318.GL21801@redhat.com>
In-Reply-To: <20120410185318.GL21801@redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-10 20:53, Vivek Goyal wrote:
> On Tue, Apr 10, 2012 at 08:41:08PM +0200, Jens Axboe wrote:
> 
> [..]
>>> So we are back to the question of can scsi devices find out if a Lun
>>> is backed by single disk or multiple disks.
>>
>> The cleanest would be to have the driver signal these attributes at
>> probe time. You could even adjust CFQ properties based on this, driving
>> the queue depth harder etc. Realistically, going forward, most fast
>> flash devices will be driven by a noop-like scheduler on multiqueue. So
>> CPU cost of the IO scheduler can mostly be ignored, since CFQ cost on
>> even big RAIDs isn't an issue due to the low IOPS rates.
> 
> Agreed that on RAID CPU cost is not a problem. Just that idling and low
> queue depth kills the performance.

Exactly, and both of these are trivially adjustable as long as we know
when to do it.

> So apart from "rotational" if driver can give some hints about underlying
> devices being RAID (or multi device), it will help. Just that it looks
> like scsi does not have a way to determine that.

This sort of thing should be done with a udev rule. It should not be too
hard to match for the most popular arrays, catching the majority of the
setups by default. Or you could ask the SCSI folks for some heuristics,
it's not unlikely that a few different attributes could make that bullet
proof, pretty much.

-- 
Jens Axboe

