Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1FMVUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:20:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54632 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab1FMVUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:20:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uBcCiBP0KJBoIUjICDDd0ei/ptaTkVRU+Xh/X0MMGttI6SzoWTdKi6kPNxsiM6ERHf
         Ii71V1meIuwNjsad68wIXxqKMxfUoja5lbKoyBxmEqLMKvBt/w48dL4ijGurQuAUns/a
         51vTJpzPvAuYizxsKP86FpRxYqZ1DGFEOJAok=
Date: Mon, 13 Jun 2011 14:20:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>,
        Tejun Heo <tj@kernel.org>
Cc: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
Subject: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040
 vibrator
Message-ID: <20110613212028.GA13138@core.coreip.homeip.net>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <1307706876-4768-12-git-send-email-peter.ujfalusi@ti.com>
 <20110611231854.GA3979@core.coreip.homeip.net>
 <1530216.k8lJ4nKZ1s@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1530216.k8lJ4nKZ1s@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 12:51:16PM +0300, Péter Ujfalusi wrote:
> On Sunday 12 June 2011 01:18:54 Dmitry Torokhov wrote:
> 
> > > +static int twl6040_vibra_open(struct input_dev *input)
> > > +{
> > > +     struct vibra_info *info = input_get_drvdata(input);
> > > +
> > > +     info->workqueue = create_singlethread_workqueue("vibra");
> > > +     if (info->workqueue == NULL) {
> > > +             dev_err(&input->dev, "couldn't create workqueue\n");
> > > +             return -ENOMEM;
> > > +     }
> > 
> > Why do we need to create a separate workqueue? With arrival of CWQ
> > it looks like we should be able to use one of the system-wide
> > workqueues for this.
> 
> The reason for this is to ensure that we have the lowest latency as possible 
> in most case. In the embedded devices we use the vibra for tactile type of 
> feedbacks as well, where few tens of ms delay can be felt.

Even if you create a dedicated workqueue with CWQ it will still be using
shared pool of threads so I do not think that latency will be affected
by using system-wide workqueue. I might be mistaken though, Tejun will
correct me if I am wrong...

Thanks.

-- 
Dmitry
