Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1IEDUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 23:20:10 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:31834 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1IEDUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 23:20:05 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 2/6] Input: elantech - use firmware provided x, y ranges
In-Reply-To: <4E5FCE58.9060906@canonical.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-3-git-send-email-jj_ding@emc.com.tw> <20110818074756.GE10093@core.coreip.homeip.net> <4E5FCE58.9060906@canonical.com>
User-Agent: Notmuch/0.7 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 05 Sep 2011 11:22:18 +0800
Message-ID: <87sjobk711.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

On Thu, 01 Sep 2011 11:26:32 -0700, Chase Douglas <chase.douglas@canonical.com> wrote:
> On 08/18/2011 12:47 AM, Dmitry Torokhov wrote:
> > On Thu, Aug 18, 2011 at 09:57:05AM +0800, JJ Ding wrote:
> >> +
> >> +		i = (etd->fw_version > 0x020800 &&
> >> +		     etd->fw_version < 0x020900) ? 1 : 2;
> >> +		*x_max = (etd->capabilities[1] - i) * 64;
> >> +		*y_max = (etd->capabilities[2] - i) * 64;
> >> +		*y_2ft_max = (*y_max - i) * 64 / 4;
> > 
> > Hmm, we should have the same range for ST and MT data and scale MT data
> > if it has lower resolution to match ST.
> 
> I saw this go by a while back and it made sense to me at the time.
> However, I've had some thoughts that give me pause.
> 
> Seth Forshee has been working on getting a semi-mt driver for ALPS
> devices. The ALPS devices have an interesting mechanism for providing
> multitouch data, but it boils down to having a resolution of only 15
> values in the X axis and 11 in the Y axis (it looks possible to
> extrapolate and get double the resolution, but my point will remain).
> 
> Let's take the X synaptics module as an example of the repercussions of
> in-kernel axis scaling. The X synaptics module translates two touch
> drags into scroll events. Synaptics will want to use the highest
> resolution axis for generating scroll events. If both the MT and ST axes
> have the same resolution, it might pick the MT axes for scrolling. On
> ALPS devices with in-kernel axis scaling that would be a bad choice.
I don't know about the ALPS devices, but since we already report
ABS_MT_POSITION_{X,Y} with elantech v2, we have to do the scaling in
kernel anyway to adhere to multitouch protocol. So I would say it is
still more appropriate to have the same resolution for ST and MT with
respect to elantech v2. Maybe ALPS should be considered an exception to this?
> It's trivial to project the MT and ST axes onto each other in userspace.
> I suggest we report the real range and resolution of ST and MT axes
> independently.

> -- Chase
