Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab1LHXgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 18:36:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40050 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1LHXgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 18:36:48 -0500
Date: Fri, 9 Dec 2011 03:36:43 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Hughes <hughsient@gmail.com>,
        Daniel Nicoletti <dantti12@gmail.com>, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, vojtech@ucw.cz,
        Przemo Firszt <przemo@firszt.eu>, Richard Hughes <richard@hughsie.com>
Subject: Re: [GIT PULL] power_supply: add power supply scope
Message-ID: <20111208233643.GA19022@oksana.dev.rtsoft.ru>
References: <CACo8zOcvKwr0wDkytvJfqyx4kV0ceYyCt+qnDqiSgxNywpzeHg@mail.gmail.com>
 <4ED9BDF8.3010600@goop.org>
 <CAD2FfiE-rg-1bMmVpYzBhnQcBMKKKO4WPnu0bvx+pvdFnpARrQ@mail.gmail.com>
 <4EDE4C7A.1010802@goop.org>
 <CAD2FfiHWuEmVTa54YqfJDk5zHpSQuM_nwPT=mR6NoWpajpydpg@mail.gmail.com>
 <4EDFA192.7000602@goop.org>
 <CAD2FfiF+fVoLPWpPyGGKdnoGhx1f=Loh2Ju-vdU58Y=2kf6C3g@mail.gmail.com>
 <4EE015D1.5070005@goop.org>
 <20111208104127.GA1753@oksana.dev.rtsoft.ru>
 <4EE0EB7B.6060807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4EE0EB7B.6060807@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 08:53:15AM -0800, Jeremy Fitzhardinge wrote:
> Yes.  That patch was mostly so I could test the mechanism.  Certainly
> general rule is that if there's no scope attribute then assume System.

Okay, great.

> > /sys/class/power_supply/battery/supplicants/<device_name>
> > is a symlink to /sys/class/HID/.../device.
> >
> > With a special meaning of an empty directory (or non-existent, or w/ a
> > symlink pointing to '/sys/devices/system') -- system power.
> 
> Yes.  That's awkward to implement because the kobj isn't exported from
> device/base.  But aside from that, its a somewhat awkward interface for
> usermode, because it has to end up following symlink and resolving their
> paths, and then having special hardcoded knowledge of what particular
> paths mean.  When all upower really wants to know is "do I need to
> suspend when this supply gets low?".

Mm... OK. I think you're right. The 'scope' thing is indeed useful by
itself.

> > That way we may describe any possible power hierarchy.
> >
> > From the implementation point of view, for now power_supply may just
> > conditionally (by introducing power_supply.not_system_power flag)
> 
> How is that different from scope?

No different at all, I'm fine with either power_supply.scope or any
other flag. :-)

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
