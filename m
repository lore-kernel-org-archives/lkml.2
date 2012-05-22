Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386Ab2EVT7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:59:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43847 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760300Ab2EVT7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:59:30 -0400
MIME-Version: 1.0
In-Reply-To: <24289717.tQzdZ5Ax07@avalon>
References: <4F12D7A0.7030804@redhat.com>
	<CAMuHMdV+ub7t_O5mu1vWrZFZOhZ7NYZfnoBWPyfK2bYQUT4yPw@mail.gmail.com>
	<24289717.tQzdZ5Ax07@avalon>
Date: Tue, 22 May 2012 21:59:29 +0200
X-Google-Sender-Auth: 6R6oJEclRTy3XAzY7gvEXKv_aU8
Message-ID: <CAMuHMdUox7MKzAM6etq6ptLyyxUMSZwSyXrfuTc-bvLiVrMhwA@mail.gmail.com>
Subject: Re: [GIT PULL for 3.3-rc1] media updates
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Bob Liu <lliubbo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Mon, Apr 30, 2012 at 1:23 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 25 April 2012 17:12:49 Geert Uytterhoeven wrote:
>> On Sun, Jan 15, 2012 at 14:41, Mauro Carvalho Chehab wrote:
>> > Laurent Pinchart (18):
>> >      [media] uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
>> >      [media] uvcvideo: Use videobuf2-vmalloc
>>
>> It seems these change (3d95e932573c316ad56b8e2f283e26de0b9c891c
>> resp. 6998b6fb4b1c8f320adeee938d399c4d8dcc90e2) broke the
>> build for nommu a while ago, as uvc_queue_get_unmapped_area() was not
>> or was incorrectly updated:
>>
>> drivers/media/video/uvc/uvc_queue.c:254:23: error: 'struct
>> uvc_video_queue' has no member named 'count'
>> drivers/media/video/uvc/uvc_queue.c:255:18: error: 'struct
>> uvc_video_queue' has no member named 'buffer'
>> drivers/media/video/uvc/uvc_queue.c:256:19: error: 'struct vb2_buffer'
>> has no member named 'm'
>> drivers/media/video/uvc/uvc_queue.c:259:16: error: 'struct
>> uvc_video_queue' has no member named 'count'
>> drivers/media/video/uvc/uvc_queue.c:263:23: error: 'buf' undeclared
>> (first use in this function)
>>
>> Cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/6171077/
>
> My bad, and thanks for the report. The following patch should fix this. Do you
> have a NOMMU system to test it on ?

No, I don't.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
