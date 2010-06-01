Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab0FASJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 14:09:34 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44054 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab0FASJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 14:09:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=mYIj34jspiJKii+fp6QJJaWRL9fV9bG/xPuFyYjCMzX78GpqiqGHiQAMIQbjAnhOi
	xpsqULpe8m8nyQ95bNTRQ==
MIME-Version: 1.0
In-Reply-To: <1275414172.27810.27961.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	<tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	<1275136178.27810.13539.camel@twins>
	<1275139902.27810.13737.camel@twins>
	<AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	<1275412748.27810.27883.camel@twins>
	<AANLkTilGfY1PnNgpEeB3AQEqTNoDJQfPTxK5LNUYb7ZA@mail.gmail.com>
	<1275414172.27810.27961.camel@twins>
Date: Tue, 1 Jun 2010 11:09:23 -0700
Message-ID: <AANLkTil8ly_3P2DgEI9oI_ZbYP6FkwP2lCY2v47iAn9-@mail.gmail.com>
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 10:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-06-01 at 10:34 -0700, Venkatesh Pallipadi wrote:
>>
>> Yes. This will cover all the cases on insert. But on erase, there is
>> still a case where a rotate of sibling node is done during the
>> re-coloration process. There we have a child change on sibling's
>> child. I am not able to think of any easy way to handle that case.
>
> Let me go draw some figures with pen and paper to match up the erase
> path with the rb_augment_erase_begin() code, because I can't quite spot
> the case we're missing.
>
> If you have it handy, ascii art might help..

It is this case

    P
   / \
  N   S
     / \
    SL SR

changing to

    P
   / \
  N  SL
      \
       S
        \
        SR

This can happen in __rb_erase_color, where 'other' points to sibling node.

Thanks,
Venki
