Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2DYPMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:12:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52180 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab2DYPMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <4F12D7A0.7030804@redhat.com>
References: <4F12D7A0.7030804@redhat.com>
Date: Wed, 25 Apr 2012 17:12:49 +0200
X-Google-Sender-Auth: haHX206r2Xq5DLPRUkllD5txyEE
Message-ID: <CAMuHMdV+ub7t_O5mu1vWrZFZOhZ7NYZfnoBWPyfK2bYQUT4yPw@mail.gmail.com>
Subject: Re: [GIT PULL for 3.3-rc1] media updates
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bob Liu <lliubbo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 14:41, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> Laurent Pinchart (18):
>      [media] uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
>      [media] uvcvideo: Use videobuf2-vmalloc

It seems these change (3d95e932573c316ad56b8e2f283e26de0b9c891c
resp. 6998b6fb4b1c8f320adeee938d399c4d8dcc90e2) broke the
build for nommu a while ago, as uvc_queue_get_unmapped_area() was not
or was incorrectly updated:

drivers/media/video/uvc/uvc_queue.c:254:23: error: 'struct
uvc_video_queue' has no member named 'count'
drivers/media/video/uvc/uvc_queue.c:255:18: error: 'struct
uvc_video_queue' has no member named 'buffer'
drivers/media/video/uvc/uvc_queue.c:256:19: error: 'struct vb2_buffer'
has no member named 'm'
drivers/media/video/uvc/uvc_queue.c:259:16: error: 'struct
uvc_video_queue' has no member named 'count'
drivers/media/video/uvc/uvc_queue.c:263:23: error: 'buf' undeclared
(first use in this function)

Cfr. http://kisskb.ellerman.id.au/kisskb/buildresult/6171077/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
