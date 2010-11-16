Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0KPP4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 10:56:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42683 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0KPP4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 10:56:42 -0500
MIME-Version: 1.0
In-Reply-To: <20101115144449.4e254573@notabene.brown>
References: <1287479956.1729.1.camel@yio.site> <20101019153136.b2543f7b.akpm@linux-foundation.org>
 <1287530747.1171.9.camel@yio.site> <20101115144449.4e254573@notabene.brown>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Nov 2010 16:56:26 +0100
Message-ID: <AANLkTi=Jx7OQGVGYhYU+wLkB2=6BwieR9kX-N9sLxVi2@mail.gmail.com>
Subject: Re: [PATCH] support polling of /proc/swaps
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 04:44, Neil Brown <neilb@suse.de> wrote:
> On Wed, 20 Oct 2010 01:25:47 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
>> On Tue, 2010-10-19 at 15:31 -0700, Andrew Morton wrote:
>> > On Tue, 19 Oct 2010 11:19:16 +0200
>> > Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>> > It's a bit sad that we have to add quite a pile of infrastructure to
>> > make a procfs file pollable.  I wonder if it's possible to provide some
>> > core support for this, and reduce the amount of code at each particular
>> > handler site.
>>
>> You mean something like adding the event counter to the seq_file? There
>> is /proc/self/mounts,mountinfo and /proc/swaps so far, I think.
>
> And /proc/mdstat.
>
> In /proc/mdstat I do something a little bit different.  I only update the
> per-file event number when reading the first byte of the file, rather than
> when poll returns POLL_PRI.
> This is somewhat more robust.  In general select/poll will continue returning
> a 'ready' status until the program performs some action (typically read or
> write) which makes the fd not ready any more.
>
> With your code (which I think is the same as /proc/mounts) you get at most 1
> notification per change so you have to be careful not to miss it.  It is like
> an edge triggered interrupt rather than level triggered.
>
> So if this were extracted into the seqfile library (which is probably a good
> idea), I'd like to see a suitably robust version used.

Sure, sounds good to me to have that available in the seq file. The
current logic works fine so far, but always returning from poll(),
until data is actually read(), sounds nice.

You want to give it a try how stuff moved into seq_file would look like?

Kay
