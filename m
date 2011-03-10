Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1CJNQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:16:46 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37073 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1CJNQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:16:45 -0500
Message-ID: <4D78CF3A.7000408@kernel.dk>
Date: Thu, 10 Mar 2011 14:16:42 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Philipp Reisner <philipp.reisner@linbit.com>
CC: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] DRBD bits for 2.6.39
References: <201103091523.51815.philipp.reisner@linbit.com> <201103101200.24005.philipp.reisner@linbit.com> <4D78B54B.2060803@kernel.dk> <201103101310.39012.philipp.reisner@linbit.com>
In-Reply-To: <201103101310.39012.philipp.reisner@linbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-10 13:10, Philipp Reisner wrote:
> [...]
>>
>> Now that I have your attention... Did you look at the plugging changes?
> 
> You always have it :)
> I looked at the changes, and I noticed that we no longer get the unplug
> events. 
> 
>> As Christoph mentioned, you seem to be passing plugging information on
>> the wire. What is the reason for that? With the on-stack plugging, these
>> events are not seen by the block device anymore.
>>
> 
> Imagine DRBD in synchronous mode (protocol C in DRBD speak) on an older
> kernel. We mirror a write, in order to get the write-ack packet from the
> peer, the peer needs to unplug as well. -> Send the unplug events via the
> wire.
> 
> Now, it we would connect a current-head-of-git DRBD on one node to
> a older one (which still needs unplug packets to respond quickly),
> we would have a tar pit block device. (At least for single synchronous
> writes)
> 
> We are in brainstorming mode right now here.
> One idea is to have a timer, that gets touched with every request we get
> in, in case it expires, we send out a unplug event over the wire.
> 
> But having the unplug events would be more elegant of course...

The unplug is essentially the ->request_fn() being run now. So for older
clients you could just always include an unplug even when you pulled
whatever off the queue there is and sent it to the device.

-- 
Jens Axboe

