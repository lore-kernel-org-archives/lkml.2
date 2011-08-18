Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1HRKKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 06:10:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab1HRKKP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 06:10:15 -0400
From: "Ravi, Deepthy" <deepthy.ravi@ti.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "mchehab@infradead.org" <mchehab@infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Thu, 18 Aug 2011 15:39:07 +0530
Subject: RE: [PATCH] Media controller: Define media_entity_init() and
 media_entity_cleanup() conditionally
Thread-Topic: [PATCH] Media controller: Define media_entity_init() and
 media_entity_cleanup() conditionally
Thread-Index: AcxcyUPAC48FLn/IS2S8ZDduZeEHKgAACUJgADFdQBY=
Message-ID: <ADF30F4D7BDE934D9B632CE7D5C7ACA4047C4D0907DB@dbde03.ent.ti.com>
References: <1313577276-18182-1-git-send-email-deepthy.ravi@ti.com>,<19F8576C6E063C45BE387C64729E739404E3CDE6D9@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404E3CDE6D9@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks,
Deepthy Ravi.
________________________________________
From: Hiremath, Vaibhav
Sent: Wednesday, August 17, 2011 9:00 PM
To: Ravi, Deepthy; mchehab@infradead.org; linux-media@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: RE: [PATCH] Media controller: Define media_entity_init() and media_entity_cleanup() conditionally

> -----Original Message-----
> From: Ravi, Deepthy
> Sent: Wednesday, August 17, 2011 4:05 PM
> To: mchehab@infradead.org; linux-media@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: linux-omap@vger.kernel.org; Hiremath, Vaibhav; Ravi, Deepthy
> Subject: [PATCH] Media controller: Define media_entity_init() and
> media_entity_cleanup() conditionally
>
> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> Defines the two functions only when CONFIG_MEDIA_CONTROLLER
> is enabled.
[Hiremath, Vaibhav] Deepthy,

You may want to mention about build failure without MEDIA_CONTROLLER option being enabled, especially if any sensor driver is being used between MC and non-MC framework compatible devices.
For example, OMAP3 and AM3517, where TVP5146 is being used but OMAP3 is based on MC framework and AM3517 is based on simple sub-dev based interface.

[Deepthy Ravi] Ok. I will change description to include that.

Thanks,
Vaibhav
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
>       int top;
>  };
>
> +#ifdef CONFIG_MEDIA_CONTROLLER
>  int media_entity_init(struct media_entity *entity, u16 num_pads,
>               struct media_pad *pads, u16 extra_links);
>  void media_entity_cleanup(struct media_entity *entity);
> +#else
> +static inline int media_entity_init(struct media_entity *entity, u16
> num_pads,
> +             struct media_pad *pads, u16 extra_links)
> +{
> +     return 0;
> +}
> +static inline void media_entity_cleanup(struct media_entity *entity) {}
> +#endif
>
>  int media_entity_create_link(struct media_entity *source, u16 source_pad,
>               struct media_entity *sink, u16 sink_pad, u32 flags);
> --
> 1.7.0.4

