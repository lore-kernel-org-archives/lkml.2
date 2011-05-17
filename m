Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab1EQP1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:27:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50219 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab1EQP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q1t0TgGqUTOZLIuBusUbISFO0+h0mkPFqApJFnA8kSQyCBP0dYeIijQtmh7HF4mtcq
         r1i2LrAjlNRlqgtS3sAgbIKb13wKSle+4ID7QxRi9GNhEFQsUjZk9o5DscrxNNwz6cH5
         U+QBevZMjmIkWjFJAwr1BV+H1qLmjUqK+RLpk=
Date: Tue, 17 May 2011 17:27:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110517152742.GR20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
 <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org>
 <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 17, 2011 at 08:15:38AM -0700, Linus Torvalds wrote:
> Semantically what it is is a LOCK.

Okay, an outer mutex then.

> You want the locking for the whole "do I need to wait for the
> completion" thing anyway, so why mess things up?

Spinlock inside mutex seemed a bit strange but yeah that probably is
the simpliest way.

Thanks.

-- 
tejun
