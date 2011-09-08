Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1IHHtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 03:49:51 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4639 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1IHHtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 03:49:49 -0400
Date: Thu, 08 Sep 2011 09:49:14 +0200
Subject: Re: Can you review or ack this patch?
Message-ID: <mb4qm7m8fdvcxgd7l5278ckf.1315468154963@email.android.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p887oFVX024326

Hi Andrew,

Sorry for top-posting, I only have a crappy Android mailer at the moment.

Thank you for looking at this. Unfortunately I am dealing with a family emergency at the moment (and for the next 1-2 weeks), so I don't have the time or motivation to follow up on this. So if you or Mauro (or someone else for that matter) can fix the two issues you found, then that would be helpful.

Alternatively, I can also make a follow-on patch later once things have settled down for me.

I guess that multiple-assignment thing is something that anyone can correct of course.

Regards,

     Hans

Andrew Morton <akpm@linux-foundation.org> wrote:

>On Tue, 23 Aug 2011 08:33:25 +0200
>Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>> (and resent again, this time with the correct linux-fsdevel mail address)
>> (Resent as requested by Andrew Morton since this is still stuck)
>> 
>> Hi Al, Andrew,
>> 
>> Can you take a look at this patch and send an Ack or review comments?
>> 
>> It's already been reviewed by Jon Corbet and we really need this functionality
>> for v3.1. You were in the CC list in earlier postings:
>> 
>> Here: http://www.spinics.net/lists/linux-fsdevel/msg46753.html
>> and here: http://www.mail-archive.com/linux-media@vger.kernel.org/msg34546.html
>> 
>> The patch also featured on LWN: http://lwn.net/Articles/450658/
>> 
>> Without your ack Mauro can't upstream this and we have a number of other
>> patches that depend on this and are currently blocked.
>> 
>> We would prefer to upstream this patch through the linux-media git tree
>> due to these dependencies.
>> 
>> My git branch containing this and the dependent patches is here:
>> 
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/poll
>> 
>> Your help would be greatly appreciated (and your ack even more :-) )!
>
>I'll grab the patch to get it a bit of testing while Al cogitates.
>
>> 
>> 
>> [PATCH] poll: add poll_requested_events() function
>> 
>> In some cases the poll() implementation in a driver has to do different
>> things depending on the events the caller wants to poll for. An example is
>> when a driver needs to start a DMA engine if the caller polls for POLLIN,
>> but doesn't want to do that if POLLIN is not requested but instead only
>> POLLOUT or POLLPRI is requested. This is something that can happen in the
>> video4linux subsystem.
>> 
>> Unfortunately, the current epoll/poll/select implementation doesn't provide
>> that information reliably. The poll_table_struct does have it: it has a key
>> field with the event mask. But once a poll() call matches one or more bits
>> of that mask any following poll() calls are passed a NULL poll_table_struct
>> pointer.
>> 
>> The solution is to set the qproc field to NULL in poll_table_struct once
>> poll() matches the events, not the poll_table_struct pointer itself. That
>> way drivers can obtain the mask through a new poll_requested_events inline.
>> 
>> The poll_table_struct can still be NULL since some kernel code calls it
>> internally (netfs_state_poll() in ./drivers/staging/pohmelfs/netfs.h). In
>> that case poll_requested_events() returns ~0 (i.e. all events).
>> 
>> Since eventpoll always leaves the key field at ~0 instead of using the
>> requested events mask, that source was changed as well to properly fill in
>> the key field.
>
>It would be nice to find some suitable place in the code where we can
>explain all this to other potential users of the capability.  Perhaps
>the implementation site for the currently undocumented
>poll_requested_events() would be a suitable place.
>
>>
>> ...
>>
>> -	epi->event.events = event->events;
>> +	epi->event.events = pt.key = event->events;
>
>coding style nit: we generally try to avoid multiple assignemnts like this.
>
>>
>> ...
>>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
