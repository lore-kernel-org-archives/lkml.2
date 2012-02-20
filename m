Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab2BTT00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:26:26 -0500
Received: from mailfe03.c2i.net ([212.247.154.66]:40005 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657Ab2BTT0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:26:25 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Feb 2012 14:26:25 EST
X-T2-Spam-Status: No, hits=-0.2 required=5.0 tests=ALL_TRUSTED,
	BAYES_50
From: Hans Petter Selasky <hselasky@c2i.net>
To: James Hogan <james@albanarts.com>
Subject: Re: [BUG] divide by zero in uvc_video_clock_update, v3.3-rc4
Date: Mon, 20 Feb 2012 20:19:32 +0100
User-Agent: KMail/1.13.5 (FreeBSD/8.3-PRERELEASE; KDE/4.4.5; amd64; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120219234151.GA32005@balrog>
In-Reply-To: <20120219234151.GA32005@balrog>
X-Face: 'mmZ:T{)),Oru^0c+/}w'`gU1$ubmG?lp!=R4Wy\ELYo2)@'UZ24N@d2+AyewRX}mAm;Yp
	|U[@,_z/([?1bCfM{_"B<.J>mICJCHAzzGHI{y7{%JVz%R~yJHIji`y>Y}k1C4TfysrsUI
	-%GU9V5]iUZF&nRn9mJ'?&>O
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202202019.32756.hselasky@c2i.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 February 2012 00:41:51 James Hogan wrote:
> Hi,
> 
> I just tried v3.3-rc4 on an Acer Aspire One Happy 2 netbook. I happened
> to open the settings dialog box of kopete, which shows a view of the
> webcam. The kernel switched to a text console with a register dump (see
> below), indicating a divide error in uvc_video_clock_update.
> 
> The IP is on 7482, a divide, presumably by %r11 (see objdump output below)
> which is 0 in the register dump. It appears to be the div_u64 in
> uvc_video_clock_update().
> 
> I haven't tried any other recent kernel versions.
> 
> My asm is rusty and I don't really have any time to look further into it.
> Is this enough to go on?
> 
> Thanks
> James

Hi,

This is a known issue which has been fixed by:

http://git.linuxtv.org/pinchartl/uvcvideo.git/commit/5c97eb2eb9c45dad8825de7754ceb33699451978

--HPS
