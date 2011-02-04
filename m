Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1BDMeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:34:15 -0500
Received: from smtp.nokia.com ([147.243.128.24]:26410 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab1BDMeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:34:13 -0500
Message-ID: <4D4BF23A.1050800@maxwell.research.nokia.com>
Date: Fri, 04 Feb 2011 14:34:02 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101123 SeaMonkey/2.0.11
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de
Subject: Re: [PATCH v8 05/12] media: Entity use count
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-6-git-send-email-laurent.pinchart@ideasonboard.com> <201102041122.03886.hverkuil@xs4all.nl>
In-Reply-To: <201102041122.03886.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

And many thanks for the comments!

Hans Verkuil wrote:
...
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index b82f824..114541a 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -81,6 +81,8 @@ struct media_entity {
>>  	struct media_pad *pads;		/* Pads array (num_pads elements) */
>>  	struct media_link *links;	/* Links array (max_links elements)*/
>>  
>> +	int use_count;			/* Use count for the entity. */
> 
> Isn't unsigned better?

Could be. The result, though, will be slightly more difficult checking
for bad use count --- which always is a driver bug.

me->use_count += change;
WARN_ON(me->use_count < 0);

we must do something like this:

if (change < 0)
	WARN_ON(me->use_count < (unsigned)-change);
me->use_count += change;

I'd perhaps also go with unsigned int; the choice for signed was made
mainly since the above check and with signed int the check was more trivial.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
