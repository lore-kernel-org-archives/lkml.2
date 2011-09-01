Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab1IAWJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:09:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58046 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932190Ab1IAWJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:09:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [RFC][PATCH 5/5] PM / Domains: Add default power off governor function
Date: Fri, 2 Sep 2011 00:11:12 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>
References: <201108310017.03103.rjw@sisk.pl> <201108310022.43850.rjw@sisk.pl> <CAORVsuW7rFEN8u7RCpmWJamtG2iUbA_zz3ax4hgBjGAZW9vU=A@mail.gmail.com>
In-Reply-To: <CAORVsuW7rFEN8u7RCpmWJamtG2iUbA_zz3ax4hgBjGAZW9vU=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109020011.12264.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, September 01, 2011, Jean Pihet wrote:
> Rafael,
> 
> On Wed, Aug 31, 2011 at 12:22 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > Add a function deciding whether or not a given PM domain should
> > be powered off on the basis of that domain's devices' PM QoS
> > constraints.
> >
> > ---
> >  drivers/base/power/domain_governor.c |   96 +++++++++++++++++++++++++++++++++++
> >  include/linux/pm_domain.h            |    7 ++
> >  2 files changed, 103 insertions(+)
> >
> > Index: linux/include/linux/pm_domain.h
> > ===================================================================
> > --- linux.orig/include/linux/pm_domain.h
> > +++ linux/include/linux/pm_domain.h
> > @@ -49,6 +49,10 @@ struct generic_pm_domain {
> >        int (*start_device)(struct device *dev);
> >        int (*stop_device)(struct device *dev);
> >        bool (*active_wakeup)(struct device *dev);
> > +       ktime_t power_off_latency;
> > +       ktime_t power_on_latency;
> > +       s64 break_even_ns;
> > +       s64 min_delta_ns;
> How are those values populated?

I'm not sure.  There are a few possible ways to do that, but I simply
don't know which one is going to be the most useful.  That's one of
the reasons why patches [4-5/5] are RFCs.

> Is there a mechanism that dynamically updates the values?

Obviously not at the moment.

Thanks,
Rafael
