Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab1CJMKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 07:10:44 -0500
Received: from mail09.linbit.com ([212.69.161.110]:45723 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1CJMKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 07:10:43 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] DRBD bits for 2.6.39
Date: Thu, 10 Mar 2011 13:10:38 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-25-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
References: <201103091523.51815.philipp.reisner@linbit.com> <201103101200.24005.philipp.reisner@linbit.com> <4D78B54B.2060803@kernel.dk>
In-Reply-To: <4D78B54B.2060803@kernel.dk>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101310.39012.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> 
> Now that I have your attention... Did you look at the plugging changes?

You always have it :)
I looked at the changes, and I noticed that we no longer get the unplug
events. 

> As Christoph mentioned, you seem to be passing plugging information on
> the wire. What is the reason for that? With the on-stack plugging, these
> events are not seen by the block device anymore.
> 

Imagine DRBD in synchronous mode (protocol C in DRBD speak) on an older
kernel. We mirror a write, in order to get the write-ack packet from the
peer, the peer needs to unplug as well. -> Send the unplug events via the
wire.

Now, it we would connect a current-head-of-git DRBD on one node to
a older one (which still needs unplug packets to respond quickly),
we would have a tar pit block device. (At least for single synchronous
writes)

We are in brainstorming mode right now here.
One idea is to have a timer, that gets touched with every request we get
in, in case it expires, we send out a unplug event over the wire.

But having the unplug events would be more elegant of course...

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
