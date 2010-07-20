Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0GTTLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:11:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39049 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564Ab0GTTK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:10:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UFXmePpSzyRqP6AUgZ9BKkppCc+Eto5EnTZzVav4kMC3ke8Fy+nbIo1QxAuksqHNTN
         OEOOKP0Xi6aIg/tl+IIxjP7Yt+9/go7n3Kit+PvSHUcp/MsZom3UI2MLIMhwILEa1KIT
         2gc6VIGwqvjVUeOmb8EHAm2e9Xr+DinAp47As=
MIME-Version: 1.0
In-Reply-To: <20100720142647.GA8967@redhat.com>
References: <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	<x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
	<20100713195650.GA21044@redhat.com>
	<x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
	<20100713204236.GB21044@redhat.com>
	<x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
	<20100720141102.GA6316@infradead.org>
	<20100720142647.GA8967@redhat.com>
Date: Tue, 20 Jul 2010 21:10:56 +0200
Message-ID: <AANLkTimxrPLaAoH28PuxggHr99G9Xq8GlHaDJEd_QhNT@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        axboe@kernel.dk, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 4:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Jul 20, 2010 at 10:11:03AM -0400, Christoph Hellwig wrote:
>> Didn't you guys have a previous iteration of the fixes that gets
>> rid of REQ_NODILE by improving the heuristics inside cfq?  That
>> would be much, much preffered from the filesystem point of view.
I think the previous iteration required more complex heuristics, while
this one uses existing ones to handle one more class of problems.
I understand that you still see the complexity from the fs side, but
Vivek's proposal may help also there. It only needs to be tested thoroughly.

>
> Actually in this patch, I was thinking we can probably get rid of
> RQ_NOIDLE flag and just check for WRITE_SYNC. Any WRITE_SYNC queue
> gets served on sync-noidle tree. I am wondering will we not face jbd
> thread issues with direct writes also? If yes, then not special casing
> direct IO writes and treat them same as O_SYNC writes will make sense.

Probably it is better to submit this first, since it is already
tested, and then have a different patch that can finish the work
This will help when bisecting for possible regressions, since I'm not
sure why the other writes are not already marked with RQ_NOIDLE (maybe
it was introduced for some good reason to distinguish the two sets,
and we won't know unless we find the workload where it helped).
I'll resend the current patch with Jeff's reviewed and tested tags.

Corrado

>
> I really wished that we had some blktrace of some standard workloads
> stored somewhere which we could simply replay using "btreplay" and come
> to some kind of conclusion whenever we are faced with taking such
> decisions.
>
> Thanks
> Vivek
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
