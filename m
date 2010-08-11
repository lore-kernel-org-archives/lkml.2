Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0HKQFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:05:25 -0400
Received: from gateway16.websitewelcome.com ([69.56.180.14]:48822 "HELO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754348Ab0HKQFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:05:23 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 12:05:23 EDT
Subject: Re: [2.6.35] usb 2.0 em28xx kernel panic general protection fault:
 0000 [#1] SMP RIP: 0010:[<ffffffffa004fbc5>] [<ffffffffa004fbc5>] 
 em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
From: Pete Eberlein <pete@sensoray.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>, mchehab@infradead.org,
        mrechberger@gmail.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <1843123111.20100811092547@eikelenboom.it>
References: <61936849.20100811001257@eikelenboom.it>
	 <AANLkTinVNms-vdfG-VZzkOadogaCRV+HyDAY5yhYOJSK@mail.gmail.com>
	 <1117369508.20100811005719@eikelenboom.it>
	 <AANLkTikPffMQLXcPF4-xPeZfkaAtnu7xEP0TMzYVrkgE@mail.gmail.com>
	 <1843123111.20100811092547@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 08:58:45 -0700
Message-ID: <1281542325.2360.86.camel@pete-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator886.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - sensoray.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 09:25 +0200, Sander Eikelenboom wrote:
> Hello Devin,
> 
> Yes it's completely reproducible for a change:
> 
> ffmpeg -f video4linux -r 25 -s 720x576 -i /dev/video0 out.flv
> gave an error:

Use -f video4linux2.

The -f video4linux option uses the old video4linux1 API.  I have seen
similar strange behavior when I used that ffmpeg option with a v4l2
driver I am developing.  Also, ffmpeg does not use libv4l.


> serveerstertje:/mnt/software/software# ffmpeg -f video4linux -r 25 -s 720x576 -i  /dev/video0 out.flv
> FFmpeg version r11872+debian_0.svn20080206-18+lenny1, Copyright (c) 2000-2008 Fa brice Bellard, et al.
>   configuration: --enable-gpl --enable-libfaad --enable-pp --enable-swscaler --e nable-x11grab --prefix=/usr --enable-libgsm --enable-libtheora --enable-libvorbi s --enable-pthreads --disable-strip --enable-libdc1394 --enable-shared --disable -static
>   libavutil version: 49.6.0
>   libavcodec version: 51.50.0
>   libavformat version: 52.7.0
>   libavdevice version: 52.0.0
>   built on Jan 25 2010 18:27:39, gcc: 4.3.2
> Input #0, video4linux, from '/dev/video0':
>   Duration: N/A, start: 1281511364.644674, bitrate: 165888 kb/s
>     Stream #0.0: Video: rawvideo, yuyv422, 720x576 [PAR 0:1 DAR 0:1], 165888 kb/ s, 25.00 tb(r)
> File 'out.flv' already exists. Overwrite ? [y/N] y
> Output #0, flv, to 'out.flv':
>     Stream #0.0: Video: flv, yuv420p, 720x576 [PAR 0:1 DAR 0:1], q=2-31, 200 kb/ s, 25.00 tb(c)
> Stream mapping:
>   Stream #0.0 -> #0.0
> Press [q] to stop encoding
> VIDIOCMCAPTURE: Invalid argument
> frame=    1 fps=  0 q=3.0 Lsize=      38kB time=0.0 bitrate=7687.6kbits/s
> video:37kB audio:0kB global headers:0kB muxing overhead 0.530927%
> 
> 
> 
> So I tried just:
> 
> ffmpeg -i /dev/video0 out.flv
> 
> That makes it oops allways and instantly.
> 
> --
> 
> Sander
> 
> 
> 
> 
> Wednesday, August 11, 2010, 4:33:28 AM, you wrote:
> 
> > On Tue, Aug 10, 2010 at 6:57 PM, Sander Eikelenboom
> > <linux@eikelenboom.it> wrote:
> >> Hello Devin,
> >>
> >> It's a k-world, which used to work fine (altough with another program, but I can't use that since it seems at least 2 other bugs prevent me from using my VM's :-)
> >> It's this model  http://global.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&pcid=47&ifid=17&prodid=104
> >>
> >> Tried to grab with ffmpeg.
> 
> > Is it reproducible?  Or did it just happen once?  If you have a
> > sequence to reproduce, can you provide the command line you used, etc?
> 
> > Devin
> 
> 
> 
> 


