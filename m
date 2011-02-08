Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab1BHM5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:57:37 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:33594 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1BHM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:57:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v8 05/12] media: Entity use count
Date: Tue, 8 Feb 2011 13:57:33 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.36-gentoo-r3; KDE/4.6.0; x86_64; ; )
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        clemens@ladisch.de
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <4D4BF23A.1050800@maxwell.research.nokia.com> <201102041419.19916.hverkuil@xs4all.nl>
In-Reply-To: <201102041419.19916.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102081357.34145.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

On Friday 04 February 2011 14:19:19 Hans Verkuil wrote:
> On Friday, February 04, 2011 13:34:02 Sakari Ailus wrote:
> > Hi,
> > 
> > And many thanks for the comments!
> > 
> > Hans Verkuil wrote:
> > ...
> > 
> > >> diff --git a/include/media/media-entity.h
> > >> b/include/media/media-entity.h index b82f824..114541a 100644
> > >> --- a/include/media/media-entity.h
> > >> +++ b/include/media/media-entity.h
> > >> @@ -81,6 +81,8 @@ struct media_entity {
> > >> 
> > >>  	struct media_pad *pads;		/* Pads array (num_pads elements) */
> > >>  	struct media_link *links;	/* Links array (max_links elements)*/
> > >> 
> > >> +	int use_count;			/* Use count for the entity. */
> > > 
> > > Isn't unsigned better?
> > 
> > Could be. The result, though, will be slightly more difficult checking
> > for bad use count --- which always is a driver bug.
> > 
> > me->use_count += change;
> > WARN_ON(me->use_count < 0);
> > 
> > we must do something like this:
> > 
> > if (change < 0)
> > 
> > 	WARN_ON(me->use_count < (unsigned)-change);
> > 
> > me->use_count += change;
> > 
> > I'd perhaps also go with unsigned int; the choice for signed was made
> > mainly since the above check and with signed int the check was more
> > trivial.
> 
> I saw this WARN_ON as well. I think there is a good reason for that
> WARN_ON, but I think a comment in the header explaining why it is an int
> will be useful. If I trip over it, then others will as well :-)

I'll add a comment. Thanks.

-- 
Regards,

Laurent Pinchart
