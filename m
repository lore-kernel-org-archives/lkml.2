Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab2HEVF7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:05:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42185 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab2HEVFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:05:52 -0400
Date: Sun, 5 Aug 2012 23:06:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: ignore disconnected <-> unknown status changes
Message-ID: <20120805210611.GF12232@phenom.ffwll.local>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Knut Petersen <Knut_Petersen@t-online.de>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <501A2A6F.4030502@t-online.de>
 <CADnq5_OVmCds-xaPB7VsOhLd-4QSVwq9nHHarvmy9mQ8T_sNpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_OVmCds-xaPB7VsOhLd-4QSVwq9nHHarvmy9mQ8T_sNpg@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 09:32:44AM -0400, Alex Deucher wrote:
> On Thu, Aug 2, 2012 at 3:21 AM, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> > On an AOpen i915GMm-hfs the hotplug events generated
> > by transitions between connector_status_unknown and
> > connector_status_disconnected cause screen distortions.
> >
> > The attached patch cures the problem by disabling the
> > generation of hotplug events in those cases. That should
> > be safe for everybody as the only relevant changes are
> > those from / to connector_status_connected.
> 
> Seems reasonable to me.  We should just drop unknown.

We (ab)use that in i915 to avoid some (more costly) load-detection tricks
in the hotplug code (but only on rather ancient hw), instead returning
unknown. When userspace then inquires the connector status, we flip-flop
back to connected. The issue is that we need to avoid these, for the
current kms locking would stall the cursor for a while, which is not
acceptable to do every 10s. Until the kms locking is fixed, we hence can't
drop the unknown state.

> Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
