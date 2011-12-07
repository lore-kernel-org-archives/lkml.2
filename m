Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1LGLAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 06:00:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1LGLAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 06:00:05 -0500
Date: Wed, 7 Dec 2011 16:29:55 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/12] virtio: console: Add freeze and restore
 handlers to support S4
Message-ID: <20111207105955.GJ4651@amit-x200.redhat.com>
References: <cover.1323199985.git.amit.shah@redhat.com>
 <9f09629340556ddac37135bc3aab233f1154f86a.1323199985.git.amit.shah@redhat.com>
 <20111207104323.GE8326@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207104323.GE8326@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 07 Dec 2011 [12:43:24], Michael S. Tsirkin wrote:

> > diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> > index e14f5aa..fd2fd6f 100644
> > --- a/drivers/char/virtio_console.c
> > +++ b/drivers/char/virtio_console.c
> > @@ -1844,6 +1844,60 @@ static unsigned int features[] = {
> >  	VIRTIO_CONSOLE_F_MULTIPORT,
> >  };
> >  
> > +#ifdef CONFIG_PM
> > +static int virtcons_freeze(struct virtio_device *vdev)
> > +{
> > +	struct ports_device *portdev;
> > +	struct port *port;
> > +
> > +	portdev = vdev->priv;
> > +
> > +	vdev->config->reset(vdev);
> 
> 
> So here, cancel_work_sync might still be running.
> If it does run, might it try to access the device
> config?  Could not determine this quickly, if yes it's a problem.

Similar to the other comment: I don't see why just resetting device
can cause config queue access to go bad.

		Amit
