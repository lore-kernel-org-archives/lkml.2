Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0GMPdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:33:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33998 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965Ab0GMPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:33:34 -0400
Message-ID: <4C3C876A.5090005@infradead.org>
Date: Tue, 13 Jul 2010 12:34:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the v4l-dvb tree
References: <20100706175332.952fec90.sfr@canb.auug.org.au> <201007061018.21674.laurent.pinchart@ideasonboard.com> <20100706185132.7dd72993.sfr@canb.auug.org.au> <201007061310.06197.laurent.pinchart@ideasonboard.com> <4C3322EB.2050806@infradead.org> <20100707151355.GB2121@kroah.com>
In-Reply-To: <20100707151355.GB2121@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-07-2010 12:13, Greg KH escreveu:
> On Tue, Jul 06, 2010 at 09:34:51AM -0300, Mauro Carvalho Chehab wrote:
>> Em 06-07-2010 08:10, Laurent Pinchart escreveu:
>>> Hi Stephen,
>>>
>>> On Tuesday 06 July 2010 10:51:32 Stephen Rothwell wrote:
>>>> On Tue, 6 Jul 2010 10:18:20 +0200 Laurent Pinchart wrote:
>>>>>> diff --cc include/linux/usb/video.h
>>>>>> index 2d5b7fc,429c91a..0000000
>>>>>> --- a/include/linux/usb/video.h
>>>>>> +++ b/include/linux/usb/video.h
>>>>>> @@@ -160,12 -160,402 +160,409 @@@
>>>>>
>>>>> [snip]
>>>>>
>>>>>>  +/* 4.1.2. Control Capabilities */
>>>>>>  +#define UVC_CONTROL_CAP_GET                           (1 << 0)
>>>>>>  +#define UVC_CONTROL_CAP_SET                           (1 << 1)
>>>>>>  +#define UVC_CONTROL_CAP_DISABLED                      (1 << 2)
>>>>>>  +#define UVC_CONTROL_CAP_AUTOUPDATE                    (1 << 3)
>>>>>>  +#define UVC_CONTROL_CAP_ASYNCHRONOUS                  (1 << 4)
>>>>>>  +
>>>>>
>>>>> Can you move those to the first part of the header file, with the other
>>>>> constants ?
>>>>
>>>> Sure, I just put it there because of the section numbering in the
>>>> comments.  This, of course, will not influence how the file looks after
>>>> Linus merges it - unless the conflict is fixed up by one of the
>>>> maintainers before Linus gets it.
>>>
>>> I had the impression that the conflict resolutions in linux-next would end up 
>>> in mainline. I must have been wrong, sorry.
>>>
>>> Mauro, can the uvc-gadget patches go through the linux-media tree ?

It will not be simple to fix this conflict from my tree. I tried to apply them
against a 2.6.35-rc5, but it failed:

|diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
|index 47b20e7..ac27245 100644
|--- a/drivers/media/video/uvc/uvcvideo.h
|+++ b/drivers/media/video/uvc/uvcvideo.h
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
can't find file to patch at input line 73
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/drivers/usb/gadget/f_uvc.c b/drivers/usb/gadget/f_uvc.c
|index fc2611f..b6aed97 100644
|--- a/drivers/usb/gadget/f_uvc.c
|+++ b/drivers/usb/gadget/f_uvc.c
--------------------------
No file to patch.  Skipping patch.
5 out of 5 hunks ignored
can't find file to patch at input line 138
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/drivers/usb/gadget/f_uvc.h b/drivers/usb/gadget/f_uvc.h
|index 8a5db7c..e18a663 100644
|--- a/drivers/usb/gadget/f_uvc.h
|+++ b/drivers/usb/gadget/f_uvc.h
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
can't find file to patch at input line 501
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
|index 0a705e6..b05bcb7 100644
|--- a/drivers/usb/gadget/uvc.h
|+++ b/drivers/usb/gadget/uvc.h
--------------------------
No file to patch.  Skipping patch.
2 out of 2 hunks ignored
can't find file to patch at input line 555
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
|index 417fd68..98e9c8b 100644
|--- a/drivers/usb/gadget/webcam.c
|+++ b/drivers/usb/gadget/webcam.c
--------------------------
No file to patch.  Skipping patch.
12 out of 12 hunks ignored
can't find file to patch at input line 667
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff --git a/include/linux/usb/video.h b/include/linux/usb/video.h
|index 2d5b7fc..3b3b95e 100644
|--- a/include/linux/usb/video.h
|+++ b/include/linux/usb/video.h
--------------------------
No file to patch.  Skipping patch.
2 out of 2 hunks ignored
>>> Patch patches/lmml_111238_for_2_6_36_uvc_move_constants_and_structures_definitions_to_linux_usb_video_h.patch doesn't apply

It seems that the files you're patching at include/linux/usb & cia are not upstream
yet. So, just adding this patch won't solve it.

>>
>> If Greg is ok, that's fine for me.
> 
> That's fine with me.  Let me know when you have them and then I'll drop
> them from my tree.

I'll be out for vacations for some days. Greg/Laurent, it seems that the better is
to keep Stephen workaround for now, eventually applying it at Greg's tree.

Cheers,
Mauro.
