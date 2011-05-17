Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1EQPQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:16:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367Ab1EQPQf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:16:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110517151107.GQ20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org> <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org> <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 May 2011 08:15:38 -0700
Message-ID: <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 8:11 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Heh, okay.  It's not a lock tho.  It's multiple waiter waiting for a
> single event - so either explicit waitqueue or completion.  I was
> doing a waitqueue but bit waitqueue didn't seem to add too much
> complexity, so...

No.

Semantically what it is is a LOCK.

Turning it into something else just screws up everything.  It just
means you have to have ANOTHER lock to protect the things that the
completion/waitqueue would use.

Don't f*&^ around. Just make it a lock, and don't do a
"lock+completion " or something crazy.

If you can do it with a completion but with no locking, go ahead. I
doubt you can. You want the locking for the whole "do I need to wait
for the completion" thing anyway, so why mess things up?

                   Linus
