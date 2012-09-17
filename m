Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2IQH7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 03:59:07 -0400
Received: from mga14.intel.com ([143.182.124.37]:14412 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab2IQH7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 03:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,434,1344236400"; 
   d="scan'208";a="145803247"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
In-Reply-To: <CACxGe6szLVwsdNOvpB9v8pGDrygu+Go5Vf3bvpE19v3+Hkv4ww@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca> <84c8a8$5o3dgr@orsmga001.jf.intel.com> <CACxGe6u0+LC4G-87PsEK3ys7qqeJ2WnqnCdaegMK7=M9xpA8ug@mail.gmail.com> <1347628339.21322.16.camel@shinybook.infradead.org> <CACxGe6szLVwsdNOvpB9v8pGDrygu+Go5Vf3bvpE19v3+Hkv4ww@mail.gmail.com>
User-Agent: Notmuch/0.13.2+113~gc6f17a0 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 17 Sep 2012 11:03:30 +0300
Message-ID: <87a9wp84a5.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Sep 14, 2012 at 2:12 PM, David Woodhouse <dwmw2@infradead.org> wrote:
>> See https://bugzilla.redhat.com/show_bug.cgi?id=752595
>
> In that bug you mention that the intel backlight sets a bogus max of
> '1' when a backlight isn't present. I saw that too here. Here's the
> offending code:
>
> u32 intel_panel_get_max_backlight(struct drm_device *dev)
> {
>         struct drm_i915_private *dev_priv = dev->dev_private;
>         u32 max;
>
>         max = i915_read_blc_pwm_ctl(dev_priv);
>         if (max == 0) {
>                 /* XXX add code here to query mode clock or hardware clock
>                  * and program max PWM appropriately.
>                  */
>                 pr_warn_once("fixme: max PWM is zero\n");
>                 return 1;
>         }
>
> I used a quirk in my patch, but I could instead change the driver to
> bail here instead of trying to limp along.

Hi Grant, please try v3.6-rc6 that does exactly that with:

commit 28dcc2d60cb570d9f549c329b2f51400553412a1
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Mon Sep 3 16:25:12 2012 +0300

    drm/i915: do not expose a dysfunctional backlight interface to userspace

Does that fix it for you?


BR,
Jani.
