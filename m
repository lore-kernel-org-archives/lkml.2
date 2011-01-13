Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab1AMAfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 19:35:43 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:41117 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961Ab1AMAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 19:35:41 -0500
Message-ID: <75cb3b3e624d2daf7c9a414e50cfcb74.squirrel@webmail.greenhost.nl>
In-Reply-To: <b9dded$hknqnh@orsmga002.jf.intel.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
    <20110106104816.GA4026@tiehlicka.suse.cz>
    <20110111171744.GA3854@tiehlicka.suse.cz>
    <1bdc18$j7rfh5@fmsmga002.fm.intel.com>
    <b34be07ef0c3e8fc82c29d4299f262e4.squirrel@webmail.greenhost.nl>
    <b9dded$hknqnh@orsmga002.jf.intel.com>
Date: Thu, 13 Jan 2011 01:35:35 +0100 (CET)
Subject: Re: Linux 2.6.37
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Michal Hocko" <mhocko@suse.cz>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 5a1627636b35b65657045ef62631cd80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, January 12, 2011 13:07, Chris Wilson wrote:
>
> Sure, s/intel_panel_get_max_backlight/intel_panel_get_backlight/ and we
> get the behaviour we both want - preserving the current backlight unless
> none is set.

Indeed, I hadn't noticed that shortcut. That's a lot nicer than my ifdefery.

>
>> While I'm glad this problem is being fixed upstream, it would be nice to get
>> some credit for finding the source of the problem.
>
> Sorry. You found the bug but I felt your rationale was off. However, I was
> amiss in not giving you the credit you fully deserved.

Thank you very much!

The rationale was that intel_panel_set_backlight(0) was somehow called twice,
and that the current code unconditionally stored the old backlight, and thus
losing the original brightness level. This is exactly what happened. My fix
was to prevent backlight_level from being overwritten by zero. Your fix was
more structural and properly fixed backlight enabled/disabled state. In the
end both have the same effect and solve the bug. Perhaps I was unclear in
the bug description.

Anyhow, it's a pleasure working with you. I'll try to not bother you too much,
you got enough on your plate as it is. I'll leave you alone for a while after
you looked into my fix for bug 23472, after that all my Intel graphics are
pretty much solved. :-)

Take care,

Indan


