Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0KKAxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:53:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39641 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab0KKAxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:53:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: [PATCH] pm_qos: Fix reversed min and max
Date: Thu, 11 Nov 2010 01:52:34 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>, stable <stable@kernel.org>
References: <1288852803-12356-1-git-send-email-ccross@android.com> <20101104180107.GA20826@gvim.org>
In-Reply-To: <20101104180107.GA20826@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011110152.34547.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 04, 2010, mark gross wrote:
> On Wed, Nov 03, 2010 at 11:40:03PM -0700, Colin Cross wrote:
> > pm_qos_get_value had min and max reversed, causing all pm_qos
> > requests to have no effect.
> sorry.
> 
> Acked-by : mark <markgross@thegnar.org>

Applied to suspend-2.6/linux-next, will push to Linus next week.

Thanks,
Rafael

  
> > Change-Id: I252c764821eac8d94de57eb482c05bf6afcea15b
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: mark gross <markgross@thegnar.org>
> > Cc: James Bottomley <James.Bottomley@suse.de>
> > Cc: stable <stable@kernel.org>
> > Signed-off-by: Colin Cross <ccross@android.com>
> > ---
> >  kernel/pm_qos_params.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index 645e541..0da2837 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -120,10 +120,10 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
> >  
> >  	switch (o->type) {
> >  	case PM_QOS_MIN:
> > -		return plist_last(&o->requests)->prio;
> > +		return plist_first(&o->requests)->prio;
> >  
> >  	case PM_QOS_MAX:
> > -		return plist_first(&o->requests)->prio;
> > +		return plist_last(&o->requests)->prio;
> >  
> >  	default:
> >  		/* runtime check for not using enum */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

