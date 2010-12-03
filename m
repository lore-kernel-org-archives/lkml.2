Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab0LCInZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 03:43:25 -0500
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2729 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0LCInY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 03:43:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Manjunatha halli" <x0130808@ti.com>
Subject: Re: Async/N_Block V4L2 ioctls for stop hw_seek, fetch preset list
Date: Fri, 3 Dec 2010 09:42:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <901F3BF6F74A4CF79A738A2154AC8477@MINX0130808>
In-Reply-To: <901F3BF6F74A4CF79A738A2154AC8477@MINX0130808>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030942.55951.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010 06:46:40 Manjunatha halli wrote:
> Hi Mauro, Hans,
> 
> V4L2 ioctl's up until seem to be set of synchronous calls where the application tends to expect the result of the ioctl when the ioctl ends.
> However this limits us from implementing a key feature such as STOP_SEEK.
> 
> So when seeking, i.e hw_seek the application as such blocks till it gets a result. So Can this be an async call as in the application? i.e
> Suppose I send another hw_seek after this, with STOP option by making use of one of the bytes in the reserved set of the structure v4l2_hw_freq_seek?
> (like the WL1273 has used for channel_spacing)
> 
> Also today most radios tend to come with the get preset list option, i.e complete_scan feature, where in the application sends one ioctl and the radio
> gets the list of all available channels and sends it back to application, so that the application can then make use of S_FREQ to tune to any of the 
> available frequencies.
> 
> With these sort of features, can we make certain ioctls ASYNC? Non-Blocking, Can V4L2 provide a standard way of notifying back to user-space?
> Or How can we make use of the Poll, FAsync/SIGnal mechanism? In this scenario?

What you need to use is the event API. See Documentation/video4linux/v4l2-framework.txt,
section 'V4L2 events' and the event ioctls in the V4L2 spec.

In the case of a hw_seek you would set the file handle to non-blocking, call hwseek
and wait for an event to arrive. hw-seek detects whether the filehandle is blocking
or non-blocking and either operates in blocking mode (i.e. wait until finished) or
non-blocking mode where it just returns and asynchronously keeps on seeking and
sends events when something is found.

So all the building blocks are available to do this cleanly.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
