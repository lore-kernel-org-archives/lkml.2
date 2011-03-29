Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1C2L4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:56:24 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45963 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1C2L4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:56:23 -0400
Message-ID: <4D91C8E7.5070205@kernel.dk>
Date: Tue, 29 Mar 2011 13:56:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
References: <20110325151530.GA4414@swordfish.minsk.epam.com> <20110325152228.GA1707@gentoo.trippels.de> <20110325154024.GA16029@redhat.com> <4D8CB9C9.5010208@kernel.dk> <20110325185455.GA2969@redhat.com> <4D8CF202.9010809@kernel.dk> <20110326042156.GB28458@redhat.com> <20110328082321.GC16530@htj.dyndns.org> <20110328221547.GA1118@redhat.com>
In-Reply-To: <20110328221547.GA1118@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 00:15, Mike Snitzer wrote:
> On Mon, Mar 28 2011 at  4:23am -0400,
> Tejun Heo <tj@kernel.org> wrote:
> 
>> On Sat, Mar 26, 2011 at 12:21:56AM -0400, Mike Snitzer wrote:
>>> Should blk_kick_flush() process the flush request without calling
>>> elv_insert() -- like is done with open coded list_add() in
>>> blk_insert_flush()?
>>>
>>> Or should blk_insert_flush() use elv_insert() with
>>> ELEVATOR_INSERT_REQUEUE too? 
>>
>> Hmmm... I would prefer the latter.  Given that INSERT_REQUEUE and
>> FRONT are no longer different, it would probably be better to use
>> FRONT tho.  The only reason REQUEUE is used there is to avoid kicking
>> the queue from elv_insert(), which is gone now.
> 
> OK, I came up with the following patch.
> 
> Jens, this is just a natural cleanup given the code that resulted from
> the flush-merge and onstack plugging changes coming together.

That looks nice and clean. What kind of testing has been done?

-- 
Jens Axboe

