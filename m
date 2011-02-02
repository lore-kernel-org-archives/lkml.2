Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1BBDhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 22:37:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:11982 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab1BBDhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 22:37:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ID4dmZHWSTAMOjdeIxELIAZ6JRMwLwbwPpxBDwTI3nkYdKb1M+lOQkv7DLUSGUJEss
         1LiHP0Vv+NY+XJCKfjHw==
MIME-Version: 1.0
In-Reply-To: <20110201113238.60b33ff9@jbarnes-desktop>
References: <849307$bc24ct@azsmga001.ch.intel.com>
	<1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LSU.2.00.1102010909270.1586@sister.anvils>
	<20110201094643.366bc073@jbarnes-desktop>
	<20110201100833.3219687e@jbarnes-desktop>
	<AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com>
	<20110201113238.60b33ff9@jbarnes-desktop>
Date: Tue, 1 Feb 2011 19:37:09 -0800
Message-ID: <AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
From: Hugh Dickins <hughd@google.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 11:32 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> What I find strange is that you're seeing flip pending interrupts.  Are
> your symptoms affected if you remove the
> I915_DISPLAY_PLANE_[AB]_FLIP_PENDING_INTERRUPT lines from
> I915_INTERRUPT_ENABLE_FIX at the top of i915_irq.c?

No.  The first time it looked like yes it fixed it; but when I
rebooted again, same symptoms and same underruns back: this thing is
very erratic.

> Do you see any calls to drm_mode_page_flip_ioctl() in your environment?

None at all.

Sometime I should do a bisection between v2.6.36 and v2.6.37 to see
what started the underruns; but I can't promise when "sometime" will
arrive.

Hugh
