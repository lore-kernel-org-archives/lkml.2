Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1I3Qj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:39:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1I3Qj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:39:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: xiaojiang <jgq516@gmail.com>
Subject: Re: [PATCH v13 2/4] PM: Introduce devfreq: generic DVFS framework with device-specific OPPs
Date: Fri, 30 Sep 2011 18:41:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com> <1317298730-10442-3-git-send-email-myungjoo.ham@samsung.com> <4E85ADB7.1030900@gmail.com>
In-Reply-To: <4E85ADB7.1030900@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109301841.41666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 30, 2011, xiaojiang wrote:
> On 2011?09?29? 20:18, MyungJoo Ham wrote:
> > +/**
> > + * find_device_devfreq() - find devfreq struct using device pointer
> > + * @dev:	device pointer used to lookup device devfreq.
> > + *
> > + * Search the list of device devfreqs and return the matched device's
> > + * devfreq info. devfreq_list_lock should be held by the caller.
> > + */
> > +static struct devfreq *find_device_devfreq(struct device *dev)
> > +{
> > +	struct devfreq *tmp_devfreq;
> > +
> > +	if (unlikely(IS_ERR_OR_NULL(dev))) {
> > +		pr_err("DEVFREQ: %s: Invalid parameters\n", __func__);
> > +		return ERR_PTR(-EINVAL);
> > +	}
> > +	WARN(!mutex_is_locked(&devfreq_list_lock),
> > +	     "devfreq_list_lock must be*loced*.");
> A typo, it should be locked.

Thanks, I'll fix it up.

Rafael
