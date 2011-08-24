Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1HXKQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:16:56 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:46186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HXKQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:16:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Subject: Re: [PATCHv2] ISP:BUILD:FIX: Move media_entity_init() and
Date: Wed, 24 Aug 2011 12:17:11 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Vaibhav Hiremath <hvaibhav@ti.com>
References: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com>
In-Reply-To: <1313761725-6614-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241217.11430.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 August 2011 15:48:45 Deepthy Ravi wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Fix the build break caused when CONFIG_MEDIA_CONTROLLER
> option is disabled and if any sensor driver has to be used
> between MC and non MC framework compatible devices.
> 
> For example,if tvp514x video decoder driver migrated to
> MC framework is being built without CONFIG_MEDIA_CONTROLLER
> option enabled, the following error messages will result.
> drivers/built-in.o: In function `tvp514x_remove':
> drivers/media/video/tvp514x.c:1285: undefined reference to
> `media_entity_cleanup'
> drivers/built-in.o: In function `tvp514x_probe':
> drivers/media/video/tvp514x.c:1237: undefined reference to
> `media_entity_init'

If the tvp514x is migrated to the MC framework, its Kconfig option should 
depend on MEDIA_CONTROLLER.

> The file containing definitions of media_entity_init and
> media_entity_cleanup functions will not be built if that
> config option is disabled. And this is corrected by
> defining two dummy functions.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
> ---
>  include/media/media-entity.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index cd8bca6..c90916e 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -121,9 +121,18 @@ struct media_entity_graph {
>  	int top;
>  };
> 
> +#ifdef CONFIG_MEDIA_CONTROLLER
>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>  		struct media_pad *pads, u16 extra_links);
>  void media_entity_cleanup(struct media_entity *entity);
> +#else
> +static inline int media_entity_init(struct media_entity *entity, u16
> num_pads, +		struct media_pad *pads, u16 extra_links)
> +{
> +	return 0;
> +}
> +static inline void media_entity_cleanup(struct media_entity *entity) {}
> +#endif
> 
>  int media_entity_create_link(struct media_entity *source, u16 source_pad,
>  		struct media_entity *sink, u16 sink_pad, u32 flags);

-- 
Regards,

Laurent Pinchart
