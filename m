Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2DRNVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:21:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50937 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2DRNVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5h4nshdxid.wl%tiwai@suse.de>
References: <s5h4nshdxid.wl%tiwai@suse.de>
Date: Wed, 18 Apr 2012 09:21:42 -0400
Message-ID: <CADnq5_P+UE2FCgGPUoi4WuXY0oD1sEFhy3Xa+5B7myOH-jr-Gg@mail.gmail.com>
Subject: Re: [REGRESSION] 3.4-rc* radeon: No DVI-A output after commit e00e8b5e760cb
From: Alex Deucher <alexdeucher@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 8:39 AM, Takashi Iwai <tiwai@suse.de> wrote:
> Hi,
>
> I noticed that one machine here gives only the blank output with
> 3.4-rc's.  The bisection lead me to affecting commit:
>
>    commit e00e8b5e760cbbe9067daeae5454d67c44c8d035
>    Author: Alex Deucher <alexander.deucher@amd.com>
>    Date:   Fri Mar 16 12:22:09 2012 -0400
>
>    drm/radeon/kms: fix analog load detection on DVI-I connectors
>
> Reverting this commit helped, it goes back to normal.
>
> On this system, the VGA monitor is connected to DVI over a VGA-DVI
> connector (and even VGA-switcher).  So, yeah, it's a strange setup.
> But a regression is a regression.
>

I don't think it's a regression per se.  Prior to that patch, the
analog vga was using the wrong load detect function (it's using the
one for DP bridge chips) which returned connector_status_unknown if it
was called on an invalid connector.  The patch just sets the behaviour
back to the original behaviour prior to support for DP bridge chips
being added (http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=d629a3ceb4fc1ab5aab737b964100d114aba1173).
 The problem is the driver is not able to detect the monitor on the
other side of the KVM (a common problem with KVMs).  The real problem
is that some desktop environments choose to interpret
connector_status_unknown as connected.  It's not really viable to
always return connector_status_unknown as then all ports would be
considered connected when in truth they would not be.

Alex

> I'm willing to test any patch.
>
>
> thanks,
>
> Takashi
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
