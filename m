Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0K2PQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:16:19 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:55634 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621Ab0K2PQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:16:18 -0500
Date: Mon, 29 Nov 2010 10:15:52 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Keith Packard <keithp@keithp.com>
Cc: Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: i915: display doesn't get on back after returning from standby
 in 2.6.27-rc*
Message-ID: <20101129151552.GA32494@elliptictech.com>
References: <20101123123234.GA3791@tiehlicka.suse.cz>
 <20101125155828.GC9754@tiehlicka.suse.cz>
 <20101125161058.GA5831@elliptictech.com>
 <yunr5e9qjyf.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunr5e9qjyf.fsf@aiko.keithp.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-25 11:31 -0800, Keith Packard wrote:
> On Thu, 25 Nov 2010 11:10:58 -0500, Nick Bowler <nbowler@elliptictech.com> wrote:
[...]
> >   https://bugs.freedesktop.org/show_bug.cgi?id=31803
> 
> I've provided a couple of fixes that might be relevant here -- neither
> kernel nor user mode were setting the tracked DPMS state of the outputs
> to ON when doing mode setting, which caused all kinds of comedy. These
> should fix 23472 and 31803. I'm not entirely sure what's up with 23122,
> but it's possible that it's the same issue.
> 
> The user mode DPMS tracking fix is in xf86-video-intel master, the
> kernel DPMS tracking fix was sent to Chris last week.

Hi Keith,

I had a chance to test your patches this weekend:

  drm: record monitor status in output_poll_execute
  drm: Set connector DPMS status to ON in drm_crtc_helper_set_config

cherry picked from ickle's repo on top of Linus' git 0f639a3c5ca6
("Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6").

Unfortunately, they do not correct my laptop backlight issue (fdo
bugzilla #31803): the panel still dims whenever the lid is opened.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
