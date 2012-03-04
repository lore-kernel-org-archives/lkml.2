Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2CDW0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 17:26:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54767 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753474Ab2CDW03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 17:26:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Turquette, Mike" <mturquette@ti.com>
Subject: Re: [PATCH v2 RESEND] PM / devfreq: add PM QoS support
Date: Sun, 4 Mar 2012 23:30:33 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, mark gross <markgross@thegnar.org>,
        myungjoo.ham@gmail.com, Jean Pihet <jean.pihet@newoldbits.com>
References: <1330408010-25780-1-git-send-email-myungjoo.ham@samsung.com> <1330508617-6490-1-git-send-email-myungjoo.ham@samsung.com> <CAJOA=zNQ_fqVXvRdGjwB+GnQZMRzYO-WuLNZh50BMsj4V=ThyQ@mail.gmail.com>
In-Reply-To: <CAJOA=zNQ_fqVXvRdGjwB+GnQZMRzYO-WuLNZh50BMsj4V=ThyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203042330.34083.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 29, 2012, Turquette, Mike wrote:
> On Wed, Feb 29, 2012 at 1:43 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> > +       /* Check the sanity of qos_list/qos_type */
> > +       if (profile->qos_type || profile->qos_list) {
> > +               switch (profile->qos_type) {
> > +               case PM_QOS_CPU_DMA_LATENCY:
> > +               case PM_QOS_NETWORK_LATENCY:
> > +                       devfreq->qos_use_max = false;
> > +                       break;
> > +               case PM_QOS_NETWORK_THROUGHPUT:
> > +                       devfreq->qos_use_max = true;
> > +                       break;
> 
> Hello MyungJoo!
> 
> I see that you re-using the same old PM QoS handles in this
> implementation.  Do you feel this is the right way to do it?  Your
> example of using DMA for multimedia devices (given in the changelog)
> has nothing to do with network throughput, yet that constraint-type is
> used here.
> 
> I wonder if a better solution than overloading these classifications exist.
> 
> Just to toss around ideas, what about having per-device PM QoS
> throughput constraints which are generalized (e.g., not tied to a
> concept such as "network").  I've Cc'd Jean Pihet (yet again) who has
> some good experience making PM QoS-type interfaces work on a
> per-device basis.
> 
> I wonder, ultimately, if instead of feeding QoS constraints into
> devfreq if a better design might be to have devfreq feed input into a
> greater QoS framework.  E.g:
> 
> A scalable bus used by many devices might have two different device
> drivers that want to call pm_qos_device_tput(...), and also the
> devfreq driver for that bus also calls pm_qos_device_tput(...).  So
> essentially there are three points in the code where inputs can be
> driven into one common per-device QoS layer for the generic concept of
> "device throughput".  This way devfreq support is not a prerequisite
> for scaling a device in a generic way, but a nice framework for
> devices which can monitor their own activity level, built on top of a
> per-device pm qos layer.
> 
> Thoughts?

I agree with the general idea, definitely would prefer it to what is
currently being proposed.

Thanks,
Rafael
