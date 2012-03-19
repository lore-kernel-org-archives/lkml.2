Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab2CSMpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:45:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39811 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2CSMph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:45:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120319113241.GA13991@infradead.org>
References: <201203140726.q2E7Q73i021607@drepperk.user.openhosting.com>
	<20120314075842.GA337@infradead.org>
	<CACVxJT-73diTvBhDxZ=7VUz2BqaRetdnCUGk3hh+_7gyWXB6Dw@mail.gmail.com>
	<20120319113241.GA13991@infradead.org>
Date: Mon, 19 Mar 2012 14:45:36 +0200
Message-ID: <CACVxJT_4Lp3FYjsE_-pW_E3pT-hd5ARF0_2qMMJo5ooT3Y_WfA@mail.gmail.com>
Subject: Re: [PATCH] Install kernel-page-flags.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@akkadia.org>, arnd@arndb.de, davem@davemloft.net,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        linux-kernel@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 2:32 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Mar 14, 2012 at 12:40:36PM +0200, Alexey Dobriyan wrote:
>> >> Programs using /proc/kpageflags need to know about the various flags. ??The
>> >> <linux/kernel-page-flags.h> provides them and the comments in the file
>> >> indicate that it is supposed to be used by user-level code. ??But the file
>> >> is not installed.
>> >>
>> >> The patch below installs the headers and marks the unstable flags as
>> >> out-of-bounds.
>> >
>> > I don't think this is a good idea at all. ??Let's shoot the person who
>> > added that braindead interface ASAP, and replace it with one printing
>> > the flags in ASCII format.
>>
>> ASCII sucks.
>> This interface is not for humans.
>
> But we still can't lock down the page flags for a user interface - they
> are a very scare resource and we can't afford to keep them stable due
> to userspace poking into internals.
>
> I guess the best we can do is to have a translation table for kernel
> internal to external documented flags.  Once you export the header with
> the meanings it's time to add that table, even if it starts out as a 1:1
> mapping.

Well, this is totally different issue.
Translation is already there, see stable_page_flags().
