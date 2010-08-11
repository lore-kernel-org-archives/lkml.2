Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0HKH2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:28:13 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:37387 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0HKH2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:28:12 -0400
Date: Wed, 11 Aug 2010 09:25:47 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1843123111.20100811092547@eikelenboom.it>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: mchehab@infradead.org, mrechberger@gmail.com, gregkh@suse.de,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [2.6.35] usb 2.0 em28xx kernel panic general protection fault:  0000 [#1] SMP RIP: 0010:[<ffffffffa004fbc5>] [<ffffffffa004fbc5>]  em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
In-Reply-To: <AANLkTikPffMQLXcPF4-xPeZfkaAtnu7xEP0TMzYVrkgE@mail.gmail.com>
References: <61936849.20100811001257@eikelenboom.it> <AANLkTinVNms-vdfG-VZzkOadogaCRV+HyDAY5yhYOJSK@mail.gmail.com> <1117369508.20100811005719@eikelenboom.it> <AANLkTikPffMQLXcPF4-xPeZfkaAtnu7xEP0TMzYVrkgE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Devin,

Yes it's completely reproducible for a change:

ffmpeg -f video4linux -r 25 -s 720x576 -i /dev/video0 out.flv
gave an error:



serveerstertje:/mnt/software/software# ffmpeg -f video4linux -r 25 -s 720x576 -i  /dev/video0 out.flv
FFmpeg version r11872+debian_0.svn20080206-18+lenny1, Copyright (c) 2000-2008 Fa brice Bellard, et al.
  configuration: --enable-gpl --enable-libfaad --enable-pp --enable-swscaler --e nable-x11grab --prefix=/usr --enable-libgsm --enable-libtheora --enable-libvorbi s --enable-pthreads --disable-strip --enable-libdc1394 --enable-shared --disable -static
  libavutil version: 49.6.0
  libavcodec version: 51.50.0
  libavformat version: 52.7.0
  libavdevice version: 52.0.0
  built on Jan 25 2010 18:27:39, gcc: 4.3.2
Input #0, video4linux, from '/dev/video0':
  Duration: N/A, start: 1281511364.644674, bitrate: 165888 kb/s
    Stream #0.0: Video: rawvideo, yuyv422, 720x576 [PAR 0:1 DAR 0:1], 165888 kb/ s, 25.00 tb(r)
File 'out.flv' already exists. Overwrite ? [y/N] y
Output #0, flv, to 'out.flv':
    Stream #0.0: Video: flv, yuv420p, 720x576 [PAR 0:1 DAR 0:1], q=2-31, 200 kb/ s, 25.00 tb(c)
Stream mapping:
  Stream #0.0 -> #0.0
Press [q] to stop encoding
VIDIOCMCAPTURE: Invalid argument
frame=    1 fps=  0 q=3.0 Lsize=      38kB time=0.0 bitrate=7687.6kbits/s
video:37kB audio:0kB global headers:0kB muxing overhead 0.530927%



So I tried just:

ffmpeg -i /dev/video0 out.flv

That makes it oops allways and instantly.

--

Sander




Wednesday, August 11, 2010, 4:33:28 AM, you wrote:

> On Tue, Aug 10, 2010 at 6:57 PM, Sander Eikelenboom
> <linux@eikelenboom.it> wrote:
>> Hello Devin,
>>
>> It's a k-world, which used to work fine (altough with another program, but I can't use that since it seems at least 2 other bugs prevent me from using my VM's :-)
>> It's this model  http://global.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&pcid=47&ifid=17&prodid=104
>>
>> Tried to grab with ffmpeg.

> Is it reproducible?  Or did it just happen once?  If you have a
> sequence to reproduce, can you provide the command line you used, etc?

> Devin




-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

