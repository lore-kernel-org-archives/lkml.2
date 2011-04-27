Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab1D0GkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 02:40:15 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4285 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab1D0GkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 02:40:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] v4l: make sure drivers supply a zeroed struct v4l2_subdev
Date: Wed, 27 Apr 2011 08:39:33 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-tschai; KDE/4.6.1; x86_64; ; )
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1301677922-6765-1-git-send-email-herton.krzesinski@canonical.com> <201104021005.57200.hverkuil@xs4all.nl>
In-Reply-To: <201104021005.57200.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104270839.34066.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 02, 2011 10:05:57 Hans Verkuil wrote:
> On Friday, April 01, 2011 19:12:02 Herton Ronaldo Krzesinski wrote:
> > Some v4l drivers currently don't initialize their struct v4l2_subdev
> > with zeros, and this is a problem since some of the v4l2 code expects
> > this. One example is the addition of internal_ops in commit 45f6f84,
> > after that we are at risk of random oopses with these drivers when code
> > in v4l2_device_register_subdev tries to dereference sd->internal_ops->*,
> > as can be shown by the report at http://bugs.launchpad.net/bugs/745213
> > and analysis of its crash at https://lkml.org/lkml/2011/4/1/168
> > 
> > Use kzalloc within problematic drivers to ensure we have a zeroed struct
> > v4l2_subdev.
> > 
> > BugLink: http://bugs.launchpad.net/bugs/745213
> > Cc: <stable@kernel.org>
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> 
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Mauro,

Please get this patch upstream! It's a nasty 2.6.38 regression that needs to
be upstreamed urgently. The fix is simple and solves oopses in several
drivers. 2.6.38 can't be fixed as long as this fix isn't in 2.6.39.

Thanks,

	Hans

> 
> Thanks!
> 
> 	Hans
> 
> > ---
> >  drivers/media/radio/saa7706h.c  |    2 +-
> >  drivers/media/radio/tef6862.c   |    2 +-
> >  drivers/media/video/m52790.c    |    2 +-
> >  drivers/media/video/tda9840.c   |    2 +-
> >  drivers/media/video/tea6415c.c  |    2 +-
> >  drivers/media/video/tea6420.c   |    2 +-
> >  drivers/media/video/upd64031a.c |    2 +-
> >  drivers/media/video/upd64083.c  |    2 +-
> >  8 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
> > index 585680f..b1193df 100644
> > --- a/drivers/media/radio/saa7706h.c
> > +++ b/drivers/media/radio/saa7706h.c
> > @@ -376,7 +376,7 @@ static int __devinit saa7706h_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%02x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	state = kmalloc(sizeof(struct saa7706h_state), GFP_KERNEL);
> > +	state = kzalloc(sizeof(struct saa7706h_state), GFP_KERNEL);
> >  	if (state == NULL)
> >  		return -ENOMEM;
> >  	sd = &state->sd;
> > diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
> > index 7c0d777..0991e19 100644
> > --- a/drivers/media/radio/tef6862.c
> > +++ b/drivers/media/radio/tef6862.c
> > @@ -176,7 +176,7 @@ static int __devinit tef6862_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%02x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	state = kmalloc(sizeof(struct tef6862_state), GFP_KERNEL);
> > +	state = kzalloc(sizeof(struct tef6862_state), GFP_KERNEL);
> >  	if (state == NULL)
> >  		return -ENOMEM;
> >  	state->freq = TEF6862_LO_FREQ;
> > diff --git a/drivers/media/video/m52790.c b/drivers/media/video/m52790.c
> > index 5e1c9a8..303ffa7 100644
> > --- a/drivers/media/video/m52790.c
> > +++ b/drivers/media/video/m52790.c
> > @@ -174,7 +174,7 @@ static int m52790_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	state = kmalloc(sizeof(struct m52790_state), GFP_KERNEL);
> > +	state = kzalloc(sizeof(struct m52790_state), GFP_KERNEL);
> >  	if (state == NULL)
> >  		return -ENOMEM;
> >  
> > diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
> > index 5d4cf3b..22fa820 100644
> > --- a/drivers/media/video/tda9840.c
> > +++ b/drivers/media/video/tda9840.c
> > @@ -171,7 +171,7 @@ static int tda9840_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> > +	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> >  	if (sd == NULL)
> >  		return -ENOMEM;
> >  	v4l2_i2c_subdev_init(sd, client, &tda9840_ops);
> > diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
> > index 19621ed..827425c 100644
> > --- a/drivers/media/video/tea6415c.c
> > +++ b/drivers/media/video/tea6415c.c
> > @@ -152,7 +152,7 @@ static int tea6415c_probe(struct i2c_client *client,
> >  
> >  	v4l_info(client, "chip found @ 0x%x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> > -	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> > +	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> >  	if (sd == NULL)
> >  		return -ENOMEM;
> >  	v4l2_i2c_subdev_init(sd, client, &tea6415c_ops);
> > diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
> > index 5ea8404..f350b6c 100644
> > --- a/drivers/media/video/tea6420.c
> > +++ b/drivers/media/video/tea6420.c
> > @@ -125,7 +125,7 @@ static int tea6420_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> > +	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
> >  	if (sd == NULL)
> >  		return -ENOMEM;
> >  	v4l2_i2c_subdev_init(sd, client, &tea6420_ops);
> > diff --git a/drivers/media/video/upd64031a.c b/drivers/media/video/upd64031a.c
> > index f8138c7..1aab96a 100644
> > --- a/drivers/media/video/upd64031a.c
> > +++ b/drivers/media/video/upd64031a.c
> > @@ -230,7 +230,7 @@ static int upd64031a_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	state = kmalloc(sizeof(struct upd64031a_state), GFP_KERNEL);
> > +	state = kzalloc(sizeof(struct upd64031a_state), GFP_KERNEL);
> >  	if (state == NULL)
> >  		return -ENOMEM;
> >  	sd = &state->sd;
> > diff --git a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
> > index 28e0e6b..9bbe617 100644
> > --- a/drivers/media/video/upd64083.c
> > +++ b/drivers/media/video/upd64083.c
> > @@ -202,7 +202,7 @@ static int upd64083_probe(struct i2c_client *client,
> >  	v4l_info(client, "chip found @ 0x%x (%s)\n",
> >  			client->addr << 1, client->adapter->name);
> >  
> > -	state = kmalloc(sizeof(struct upd64083_state), GFP_KERNEL);
> > +	state = kzalloc(sizeof(struct upd64083_state), GFP_KERNEL);
> >  	if (state == NULL)
> >  		return -ENOMEM;
> >  	sd = &state->sd;
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
