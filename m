Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2JXXKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 19:10:53 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59427 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750710Ab2JXXKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 19:10:51 -0400
References: <1351022246-8201-1-git-send-email-elezegarcia@gmail.com> <2776796.95QghSKdPW@avalon>
User-Agent: K-9 Mail for Android
In-Reply-To: <2776796.95QghSKdPW@avalon>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/23] uvc: Replace memcpy with struct assignment
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 24 Oct 2012 19:10:45 -0400
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Julia.Lawall@lip6.fr, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Message-ID: <e8dd9233-589d-4e57-8a58-593789c8eae1@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-24_07:2012-10-24,2012-10-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=11
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1210240291
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

>Hi Ezequiel,
>
>Thanks for the patch.
>
>On Tuesday 23 October 2012 16:57:04 Ezequiel Garcia wrote:
>> This kind of memcpy() is error-prone. Its replacement with a struct
>> assignment is prefered because it's type-safe and much easier to
>read.
>> 
>> Found by coccinelle. Hand patched and reviewed.
>> Tested by compilation only.
>
>This looks good, but there's one more memcpy that can be replaced by a
>direct 
>structure assignment in uvc_ctrl_add_info() 
>(drivers/media/usb/uvc/uvc_ctrl.c). You might want to check why it
>hasn't been 
>caught by the semantic patch.
>
>> A simplified version of the semantic match that finds this problem is
>as
>> follows: (http://coccinelle.lip6.fr/)
>> 
>> // <smpl>
>> @@
>> identifier struct_name;
>> struct struct_name to;
>> struct struct_name from;
>> expression E;
>> @@
>> -memcpy(&(to), &(from), E);
>> +to = from;
>> // </smpl>
>> 
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>>  drivers/media/usb/uvc/uvc_v4l2.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
>> b/drivers/media/usb/uvc/uvc_v4l2.c index f00db30..4fc8737 100644
>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>> @@ -314,7 +314,7 @@ static int uvc_v4l2_set_format(struct
>uvc_streaming
>> *stream, goto done;
>>  	}
>> 
>> -	memcpy(&stream->ctrl, &probe, sizeof probe);
>> +	stream->ctrl = probe;
>>  	stream->cur_format = format;
>>  	stream->cur_frame = frame;
>> 
>> @@ -386,7 +386,7 @@ static int uvc_v4l2_set_streamparm(struct
>uvc_streaming
>> *stream, return -EBUSY;
>>  	}
>> 
>> -	memcpy(&probe, &stream->ctrl, sizeof probe);
>> +	probe = stream->ctrl;
>>  	probe.dwFrameInterval =
>>  		uvc_try_frame_interval(stream->cur_frame, interval);
>> 
>> @@ -397,7 +397,7 @@ static int uvc_v4l2_set_streamparm(struct
>uvc_streaming
>> *stream, return ret;
>>  	}
>> 
>> -	memcpy(&stream->ctrl, &probe, sizeof probe);
>> +	stream->ctrl = probe;
>>  	mutex_unlock(&stream->mutex);
>> 
>>  	/* Return the actual frame period. */
>
>-- 
>Regards,
>
>Laurent Pinchart
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Maybe because there is no '&' operator on the second argument. 

Regards,
Andy
