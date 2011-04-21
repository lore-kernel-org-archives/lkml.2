Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1DUOjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:39:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753863Ab1DUOjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk>
References: <20110420125824.GA3507@tiehlicka.suse.cz> <4DAEDBEB.7060904@fusionio.com>
 <20110420132903.GA13554@tiehlicka.suse.cz> <4DAF18DF.9080205@fusionio.com>
 <20110421071642.GA3556@tiehlicka.suse.cz> <5F35AAD2-8277-44BD-86B6-B1D7B816071E@kernel.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Apr 2011 07:38:57 -0700
Message-ID: <BANLkTinYv+YW6HVCodsWcCKwMmdZFsXPRA@mail.gmail.com>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at 0000000c IP: cfq_insert_request+0x1d/0x3f5
To: Jens Axboe <axboe@kernel.dk>
Cc: Michal Hocko <mhocko@suse.cz>, Jens Axboe <JAxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 12:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I am going to bisect, let's see if I can find anything.
>
> Thanks, that would be great!

I'd expect it to be very timing-dependent, and thus could easily be
triggered (or hidden) by unrelated changes.

Just happening to have a request added to the elevator at _just_ the
same moment that another CPU is changing it and getting rid of the
data structures for the old one.

        Linus
