Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab1EQWra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:47:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932456Ab1EQWr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110517152742.GR20624@htj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org> <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org> <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org> <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
 <20110517152742.GR20624@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 May 2011 15:40:11 -0700
Message-ID: <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 8:27 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Spinlock inside mutex seemed a bit strange but yeah that probably is
> the simpliest way.

Do you really even need the spinlock at all?

Just make the semaphore protect the count - and you're done.

                Linus
