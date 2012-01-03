Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2ACUdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:33:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41886 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab2ACUdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:33:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120103183741.GE31746@google.com>
References: <CAO+b5-pig48acSXAYKH09QHCL9EtzTis=mpn=OnE=cvCv+0EzA@mail.gmail.com>
	<20120103183741.GE31746@google.com>
Date: Tue, 3 Jan 2012 20:33:42 +0000
X-Google-Sender-Auth: Ht4Q6XbhhNwTqdmd9yVxmEKI6gY
Message-ID: <CAO+b5-rLSRXXSZ-puf926TFi1bWdGs4gBFNFziiVoT-7RKNEvA@mail.gmail.com>
Subject: Re: block: WARN_ON_ONCE(ev->block <= 0) triggered in __disk_unblock_events()
From: Bart Van Assche <bvanassche@acm.org>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 6:37 PM, Tejun Heo <tj@kernel.org> wrote:
> On Sun, Jan 01, 2012 at 05:22:58PM +0000, Bart Van Assche wrote:
>> In a workload that involves a lot of scsi_remove_hosts() calls (srp-ha
>> patch set stress test) I get the call stack below after about 30 to 50
>> iterations. Is this a known issue ? Does this indicate a race
>> condition in the block layer ? I can trigger this issue not only with
>> 3.2-rc7 but also with 3.1.6. I haven't tried any other kernel versions
>> yet.
>>
>> ------------[ cut here ]------------
>> WARNING: at block/genhd.c:1466 __disk_unblock_events+0xf5/0x110()
>
> It's indicating that there were more disk_unblock_events() than
> disk_block_events().  Hmmm... weird.  I'll prep a debug patch.

After having found and fixed a race condition in the (not yet
published) patch set I'm preparing that stress test ran fine for 1000
iterations. The block warning mentioned above didn't reappear and the
"blocked for more than 120 seconds" warning was gone too. Sorry for
the noise.

Bart.
