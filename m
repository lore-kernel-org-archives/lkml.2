Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab0HXDDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 23:03:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45631 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0HXDDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 23:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=GyaD+jez6J65TdZDdY15FXOm5KoPH80kI23ZI+CkkFT3X+XWPrE47l9XpL3eFeAvnV
         NUoezbrIWQZQA1l1mveg==
MIME-Version: 1.0
In-Reply-To: <20100824023028.GA9005@localhost>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
 <1282296689-25618-4-git-send-email-mrubin@google.com> <20100820100855.GC8440@localhost>
 <AANLkTi=+uNFq5=5gmjfAOhngXqR8RS3dX3E2uEWG33Ot@mail.gmail.com>
 <20100821004804.GA11030@localhost> <AANLkTim4NZrV18a2LYpyTz9+MSBgVw6KKo4tCUmu9GHZ@mail.gmail.com>
 <20100824023028.GA9005@localhost>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 23 Aug 2010 20:02:42 -0700
Message-ID: <AANLkTi=KwJat47-7GjQOhhMnriiBE5sBOR2b9b7XC6As@mail.gmail.com>
Subject: Re: [PATCH 3/4] writeback: nr_dirtied and nr_entered_writeback in /proc/vmstat
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "jack@suse.cz" <jack@suse.cz>, "riel@redhat.com" <riel@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 7:30 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> It's about the interface, I don't mind you adding the per-node vmstat
> entries which may be convenient for you and mostly harmless to others.
>
> My concern is, what do you think about the existing
> /proc/<pid>/io:write_bytes interface and is it good enough for your?
> You'll have to iterate through tasks to collect numbers for one job or
> for the whole system, however that should be easy and more flexible?

Is this as an alternative to the vmstat counters or the per node
vmstat counters?

In either case I am not sure /proc/pid will be sufficient. What if 20
processes are created, write a lot of data, then quit? How do we know
about those events later? What about jobs that wake up, write data
then quit quickly?

If we are running many many tasks I would think the amount of time it
can take to cycle through all of them might mean we might not capture
all the data.

The goal is to have a complete view of the dirtying and cleaning of
the pages over time. Using /proc/pid feels like it won't achieve that.

mrubin
