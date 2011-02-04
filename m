Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab1BDNTv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 08:19:51 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3650 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1BDNTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:19:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v8 05/12] media: Entity use count
Date: Fri, 4 Feb 2011 14:19:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2-tschai; KDE/4.4.5; x86_64; ; )
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <201102041122.03886.hverkuil@xs4all.nl> <4D4BF23A.1050800@maxwell.research.nokia.com>
In-Reply-To: <4D4BF23A.1050800@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102041419.19916.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 04, 2011 13:34:02 Sakari Ailus wrote:
> Hi,
> 
> And many thanks for the comments!
> 
> Hans Verkuil wrote:
> ...
> >> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> >> index b82f824..114541a 100644
> >> --- a/include/media/media-entity.h
> >> +++ b/include/media/media-entity.h
> >> @@ -81,6 +81,8 @@ struct media_entity {
> >>  	struct media_pad *pads;		/* Pads array (num_pads elements) */
> >>  	struct media_link *links;	/* Links array (max_links elements)*/
> >>  
> >> +	int use_count;			/* Use count for the entity. */
> > 
> > Isn't unsigned better?
> 
> Could be. The result, though, will be slightly more difficult checking
> for bad use count --- which always is a driver bug.
> 
> me->use_count += change;
> WARN_ON(me->use_count < 0);
> 
> we must do something like this:
> 
> if (change < 0)
> 	WARN_ON(me->use_count < (unsigned)-change);
> me->use_count += change;
> 
> I'd perhaps also go with unsigned int; the choice for signed was made
> mainly since the above check and with signed int the check was more trivial.

I saw this WARN_ON as well. I think there is a good reason for that WARN_ON,
but I think a comment in the header explaining why it is an int will be
useful. If I trip over it, then others will as well :-)

Regards,

	Hans

> 
> Regards,
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
