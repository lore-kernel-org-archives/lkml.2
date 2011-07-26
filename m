Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab1GZMfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:35:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49477 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab1GZMfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <yunsjpt7fjo.fsf@aiko.keithp.com>
References: <1311613829-4990-1-git-send-email-keithp@keithp.com>
 <20110725103732.623d7b65@jbarnes-desktop> <CAObL_7EqL+1rhP=9go0EnCrVwWoZqgpVw0ZmLYa99vvFBJTmGQ@mail.gmail.com>
 <yunsjpt7fjo.fsf@aiko.keithp.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 26 Jul 2011 08:35:24 -0400
X-Google-Sender-Auth: OfRvYP7PUcarys_aBjC5N06WQxk
Message-ID: <CAObL_7FTzheD0j2FW6He2GM1L-JeV9E7Z7ZGSqc2fip1_g1kQQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Hold struct_mutex during hotplug processing
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 1:54 AM, Keith Packard <keithp@keithp.com> wrote:
> From 59b920597999381fab70c485c161dd50590e561a Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Mon, 25 Jul 2011 22:37:51 -0700
> Subject: [PATCH] Revert and fix "drm/i915/dp: remove DPMS mode tracking from
>  DP"
>
> This reverts commit 885a50147f00a8a80108904bf58a18af357717f3.
>
> We actually *do* need to track DPMS state so that on hotplug, we don't
> retrain the link until DPMS is disabled.
>

>        intel_dp->output_reg = output_reg;
> +       intel_dp->dpms_mode = -1;

Should that be some actual mode constant instead of -1?

In any case, this patch, applied manually on top of the struct_mutex
fix, seems to work.  xset dpms force off turns the display off briefly
(presumably X or GNOME helpfully turns it back on), but if I let the
display turn off on its own, it comes back.

There's still an obnoxious bug, though: I use audio over DP, and when
the display turns off, the attached speaker crackles loudly for a
second or two.  I don't think it's a hardware problem with the
monitor, because if I just pull the plug it doesn't make any noise.
Should the driver do something to drop the audio link before turning
off the DP link as a whole?

--Andy
