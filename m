Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab1ERFHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 01:07:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55281 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1ERFHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 01:07:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C/6b9CNiH6B6j7TMRC+GpocruC6pZVRItf9eNSEdh3BP5I/ykbCMHW5c9EFVkE6Cca
         NYa4umVwXf1GAorRjVa5LgtD2oQs4aWkJ0ZkmeEouYiz0TgLuuBJ9j1DFq8A36jrfcYL
         NcGV/1tQ7agBvDP9FX1Za7koGIZY/zEIt8HaU=
Date: Wed, 18 May 2011 07:07:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@yahoo.com>,
        Borislav Petkov <bp@alien8.de>, Meelis Roos <mroos@linux.ee>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3 v2.6.39-rc7] block: make disk_block_events()
 properly wait for work cancellation
Message-ID: <20110518050729.GA16870@mtj.dyndns.org>
References: <20110517102713.GJ20624@htj.dyndns.org>
 <20110517102824.GK20624@htj.dyndns.org>
 <20110517102853.GL20624@htj.dyndns.org>
 <BANLkTimj2guK6kw7QSijYZyvoRY+JKgbTg@mail.gmail.com>
 <20110517151107.GQ20624@htj.dyndns.org>
 <BANLkTikpwk-hJs+TF7TJB38JsvOvHk2UMQ@mail.gmail.com>
 <20110517152742.GR20624@htj.dyndns.org>
 <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=-Ak5vhCFxgc2rt2rft0PE9XJiTA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 03:40:11PM -0700, Linus Torvalds wrote:
> On Tue, May 17, 2011 at 8:27 AM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Spinlock inside mutex seemed a bit strange but yeah that probably is
> > the simpliest way.
> 
> Do you really even need the spinlock at all?

There were sites which called disk_unblock/check_events() with
bdevlock held, which was why it was made spinlock in the first place.
Hmmm... they're not there anymore.

> Just make the semaphore protect the count - and you're done.

Yeah, with that gone, we don't even need the open-coding inside
disk_check_events().  It can simply call syncing block and unblock.
But, do you want that in -rc7?  Unnecessarily complicated as the
current code may be, converting the lock to mutex is a larger change
than adding an outer mutex and I think it would be better to do that
during the next cycle.

Thanks.

--
tejun
