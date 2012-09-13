Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab2IMKV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:21:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58815 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab2IMKV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:21:57 -0400
X-IronPort-AV: E=Sophos;i="4.80,416,1344182400"; 
   d="scan'208";a="5839749"
Message-ID: <5051B39E.8050806@cn.fujitsu.com>
Date: Thu, 13 Sep 2012 18:21:18 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/5] video:omap3isp:fix up ENOIOCTLCMD error handling
References: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com> <1346052196-32682-5-git-send-email-gaowanlong@cn.fujitsu.com> <1946796.hhZ2Ot34qB@avalon>
In-Reply-To: <1946796.hhZ2Ot34qB@avalon>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/13 18:21:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/13 18:21:19,
	Serialize complete at 2012/09/13 18:21:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 12:03 PM, Laurent Pinchart wrote:
> Hi Wanlong,
> 
> Thanks for the patch.
> 
> On Monday 27 August 2012 15:23:15 Wanlong Gao wrote:
>> At commit 07d106d0, Linus pointed out that ENOIOCTLCMD should be
>> translated as ENOTTY to user mode.
>>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
>> Cc: linux-media@vger.kernel.org
>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>> ---
>>  drivers/media/video/omap3isp/ispvideo.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/ispvideo.c
>> b/drivers/media/video/omap3isp/ispvideo.c index b37379d..2dd982e 100644
>> --- a/drivers/media/video/omap3isp/ispvideo.c
>> +++ b/drivers/media/video/omap3isp/ispvideo.c
>> @@ -337,7 +337,7 @@ __isp_video_get_format(struct isp_video *video, struct
>> v4l2_format *format) fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>>  	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
>>  	if (ret == -ENOIOCTLCMD)
>> -		ret = -EINVAL;
>> +		ret = -ENOTTY;
> 
> I don't think this location should be changed. __isp_video_get_format() is 
> called by isp_video_check_format() only, which in turn is called by 
> isp_video_streamon() only. A failure to retrieve the format in 
> __isp_video_get_format() does not really mean the VIDIOC_STREAMON is not 
> supported.
> 
> I'll apply hunks 2 to 5 and drop hunk 1 if that's fine with you.

Fine, I defer to your great knowledge in this.

Thanks,
Wanlong Gao

