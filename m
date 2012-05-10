Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864Ab2EJXYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:24:01 -0400
Received: from defout.telus.net ([204.209.205.32]:37478 "EHLO defout.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab2EJXX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:23:59 -0400
X-Greylist: delayed 3941 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2012 19:23:59 EDT
X-Authority-Analysis: v=1.1 cv=JNvv5G0IPe1OlOJmASH2x7hIc8aOLcrKeJy7TWwfV5I=
 c=1 sm=2 a=eFosVe0FMc8A:10 a=UIdm24C_LI4A:10 a=8nJEP1OIZ-IA:10
 a=pweruynyiksHeOKAIxsA:9 a=1xR5RhKHDJST4iFTkZwA:7 a=wPNLvfGTeEIA:10
X-Telus-Outbound-IP: 173.181.67.89
Message-ID: <4FAC3EA3.5080105@telusplanet.net>
Date: Thu, 10 May 2012 16:18:11 -0600
From: bob <gillb4@telusplanet.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: USB webcam UVC driver crashing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  I have a USB webcam ID 1e4e:0102.  I can start it and it runs (I 
can start various webcam applications eg: cheese, mplayer, guvcview), 
and it works ok for a few minutes, but then crashes. When it crashes, it 
usually breaks all of USB too, and occasionally the whole machine.  It 
can be the only application running and crash the machine (but in one 
instance it was 1150 seconds after starting, in another instance 453 
seconds after starting).  Some information from kern.log:

kernel: [ 2208.550294] uvcvideo: USB2.0 Camera: SOF 3205.208526 y 
990206793 ts 2209.328418 buf ts 2209.338209 (x1 210698240/143/1165 x2 
212795392/175/1196 y1 1000000000 y2 1032005663)
kernel: [ 2208.550300] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
kernel: [ 2208.550853] uvcvideo: uvc_v4l2_poll
kernel: [ 2208.558228] uvcvideo: frame 9819 stats: 0/1/252 packets, 
0/0/252 pts (!early initial), 251/252 scr, last pts/stc/sof 
3153758598/3154922431/1196
kernel: [ 2208.590196] uvcvideo: Frame complete (EOF found).
kernel: [ 2208.590199] uvcvideo: EOF in empty payload.
kernel: [ 2208.590219] uvcvideo: uvc_v4l2_poll
kernel: [ 2208.590226] uvcvideo: uvc_v4l2_ioctl(VIDIOC_DQBUF)
kernel: [ 2208.590234] uvcvideo: USB2.0 Camera: PTS 3154958118 y 
3245.189468 SOF 3245.189468 (x1 2147717982 x2 2148648054 y1 213188608 y2 
215220224 SOF offset 0)
May 10 11:54:39 Freedom kernel: [ 2208.590241] uvcvideo: USB2.0 Camera: 
SOF 3245.189468 y 990198914 ts 2209.368408 buf ts 2209.378207 (x1 
213319680/183/1205 x2 215416832/215/1236 y1 1000000000 y2 1031969188)
kernel: [ 2208.590246] uvcvideo: uvc_v4l2_ioctl(VIDIOC_QBUF)
kernel: [ 2208.590759] uvcvideo: uvc_v4l2_poll
kernel: [ 2208.598215] uvcvideo: frame 9820 stats: 0/1/253 packets, 
0/0/253 pts (!early initial), 252/253 scr, last pts/stc/sof 
3154958118/3156122524/1236
kernel: [ 2208.630178] uvcvideo: Frame complete (EOF found).
kernel: [ 2208.630181] uvcvideo: EOF in empty payload.
kernel: [ 2208.630201] uvcvideo: uvc_v4l2_poll
kernel: [ 2208.630207] uvcvideo: uvc_v4l2_ioctl(VIDIOC_DQBUF)
kernel: [ 2208.630215] uvcvideo: USB2.0 Camera: PTS 3156157638 y 
3285.170364 SOF 3285.170364 (x1 2147718555 x2 2148648626 y1 215810048 y2 
217841664 SOF offset 0)
...(rinse, repeat)...

Some of uvcdynctrl -v -l:
Listing available devices:
   video2   Hauppauge WinTV-HVR1800 [cx23885[0], PCI:0000:07:00.0]
   video1   Hauppauge WinTV-HVR1800 [cx23885, PCIe:0000:07:00.0]
   video0   USB2.0 Camera [uvcvideo, usb-0000:00:1a.7-5.1]

I also have a snip of dmesg.log, but its similar to the kern.log posted 
above.

Sorry for the long post.  My system: Linux Freedom 3.4.0-rc6 #1 SMP 
PREEMPT Mon May 7 17:11:54 MDT 2012 x86_64 x86_64 x86_64 GNU/Linux
Its not a debug kernel (but I can build one and re-run things if needed).
Its not a new bug, its been doing it for several kernels.  I have a 
different webcam that doesn't crash (doesn't use the UVC drivers), but 
the images it produces are drech.

Please mail me directly as I'm not on the list.

TIA,
Bob


