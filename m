Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab2C2Ijm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:39:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56264 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab2C2Ijh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:39:37 -0400
MIME-Version: 1.0
In-Reply-To: <1332960542_131144@CP5-2952>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
 <1332959199-32161-5-git-send-email-djkurtz@chromium.org> <1332960542_131144@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 29 Mar 2012 16:39:16 +0800
X-Google-Sender-Auth: aP-rYw67uVbimnTlY81yURzAStw
Message-ID: <CAGS+omDFwaNB6TpTsCyBa1g0LrB+VpxeD5vgSz0huUW9f6GYHw@mail.gmail.com>
Subject: Re: [PATCH 4/7 v6] drm/i915/intel_i2c: use WAIT cycle, not STOP
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 2:48 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 29 Mar 2012 02:26:36 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> The i915 is only able to generate a STOP cycle (i.e. finalize an i2c
>> transaction) during a DATA or WAIT phase.  In other words, the
>> controller rejects a STOP requested as part of the first transaction in a
>> sequence.
>
> The original docs have "this can only cause a STOP to be generated if a
> GMBUS cycle is generated, the GMBUS is currently in a data phase, or it
> is in a WAIT phase."
>
> So from that it seems STOP | INDEX? | WAIT is always a valid
> combination and is explicitly listed in the register set.
>
> I defer to actual testing though ;)

Unfortunately, STOP on first transaction didn't work for me :(.
Perhaps the docs are missing a "when":

"this can only cause a STOP to be generated if a GMBUS cycle is
generated *when* the GMBUS is currently in a data phase, or it is in a
WAIT phase."



> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
