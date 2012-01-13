Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2AMEsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 23:48:06 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37401 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572Ab2AMEsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 23:48:01 -0500
Date: Thu, 12 Jan 2012 20:47:58 -0800
From: mark gross <markgross@thegnar.org>
To: myungjoo.ham@gmail.com
Cc: "Turquette, Mike" <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH 1/2] PM / devfreq: add min/max_freq limit requested by
 users.
Message-ID: <20120113044757.GB6004@mgross-G62>
Reply-To: markgross@thegnar.org
References: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com>
 <CAJOA=zMkRxx=PhznO5VSb3H4bSx7oTYiazesasYY_X7SzSf48A@mail.gmail.com>
 <CAJ0PZbRKknwF1LwJP6M93-GPXJ9xKuzZnDjZMF8C1id026-X4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ0PZbRKknwF1LwJP6M93-GPXJ9xKuzZnDjZMF8C1id026-X4A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:08:44AM +0900, MyungJoo Ham wrote:
> On Thu, Jan 12, 2012 at 9:20 AM, Turquette, Mike <mturquette@ti.com> wrote:
> > On Wed, Jan 11, 2012 at 2:02 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> >> The frequency requested to devfreq device driver from devfreq governors
> >> is restricted by min_freq and max_freq input.
> >
> > Hello MyungJoo,
> >
> > This change appears to allow userspace to set min/max limits on
> > devfreq devices via sysfs.  Not everyone likes to expose this stuff
> > (similar to the discussions around controlling clocks from debugfs).
> >
> > Should it be wrapped in some new config option?  I think a sane
> > default is that if the sysfs config option for devfreq is selected
> > then it should include all of the read-only stuff.  A second config
> > option (which depends on the option in my previous sentence) should
> > allow the read-write stuff to be enabled separately.  Thoughts?
> >
> > Also, how are you using this feature in practice?  Is this just for
> > test or are you planning on more fine-grained control of device
> > frequencies from userspace?
> >
> > Mike
> 
> Hello Mike,
> 
> 
> Although turning off clocks inconsiderately usually crashes the
> system, setting min/max frequencies generally affects (if not always)
> only the performance and power consumption.
> 
> For the optional min/max freq, I think each device should be able to
> choose to use it or not. Thus, rather than adding a Kconfig option,
> I'll let "profile" (struct devfreq_dev_profile) include
> "expose_user_min_max_freq" option.
> 
> In practice, we have been using min/max to test DVFS behaviors and its
> side effects. And we are going to use them to 1. restrict power
> consumption forcibly by the platform software if it is too hot or the
> battery is low, and to 2. guarantee the minimum performance for
> specific tasks controlled by the platform software.
> 
> Anyway, the reason 2 could be tackled by pm-qos if we allow more
> options in pm-qos with 1. pm qos type to enforce DVFS response time.
what would pm_qos do with DVFS response time?  What power management
knob would it enable a constraint for?

pm_qos doesn't do anything but enable power throttling code to consider
a constraint on how far to throttle "something".  pm_qos has no
enforcement power.

> 2. pm qos type to enforce graphics performance. And adding a duration
> option to pm-qos requests will be helpful (sort of a helper function):
> i.e., pm_qos_timed_request(struct pm_qos_request *req, int
> pm_qos_class, s32 value, unsigned long duration_ms);

What would be good units for graphics throughput?
Where in the graphics driver would you insert the equivalent of cpufreq?
to control the GPU core frequency?

--mark

