Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2LQXRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 18:17:35 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54236 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab2LQXRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 18:17:34 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121217231501.GA7108@fancy-poultry.org>
References: <Pine.LNX.4.64.1212172322350.30738@axis700.grange>
	<20121217231501.GA7108@fancy-poultry.org>
Date: Tue, 18 Dec 2012 00:17:32 +0100
Message-ID: <CAKMK7uFf9MZpH6kDhHuaJGK6iZp_bHRT=cMbZ-oTHCkonce0gQ@mail.gmail.com>
Subject: Re: i915: GPU hang
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 12:15 AM, Heinz Diehl <htd@fancy-poultry.org> wrote:
>> [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
>> [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
>> [drm:i915_reset] *ERROR* Failed to reset chip.
>
> I have the same problem, are able to reproduce it and have bisected
> it, but the commit which git --bisect identified seems not to be the
> cause.
>
> root@wildsau linux-git]# git bisect good
> 6c085a728cf000ac1865d66f8c9b52935558b328 is the first bad commit
> commit 6c085a728cf000ac1865d66f8c9b52935558b328
> Author: Chris Wilson <ch...@chris-wilson.co.uk>
> Date:   Mon Aug 20 11:40:46 2012 +0200
>
>     drm/i915: Track unbound pages

Note that Guennadi is running kernel 3.5 which does not contain that
patch - generally there are billions of ways to hang your gpu, so
every gpu hang needs it's own bug (until we've analyzed the
error_state and triaged the bug taking other evidence into account).
Also, this is on a different gpu generation, so even more likely that
it's a different kind of hang.

Thanks, Daniel


-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
