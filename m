Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1LNBrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:47:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45214 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab1LNBrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:47:35 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <BAY151-W53C3AD24F2938042D0F733A1BC0@phx.gbl>
References: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl>
	<CAKMK7uEm8=bGWxDSbLtOEM3CBmbMSH+gWrUy0Od327ozvjOd5g@mail.gmail.com>
	<BAY151-W537E90462ED274C21FDA4CA1BE0@phx.gbl>
	<CAKMK7uH-_VzaeTsNJYL_wMfUHqMkvG-BSCxicfQ--RQ-_O5jsg@mail.gmail.com>
	<BAY151-W53C3AD24F2938042D0F733A1BC0@phx.gbl>
Date: Wed, 14 Dec 2011 02:47:33 +0100
Message-ID: <CAKMK7uGpn6AJGtbMCYWW1ziR=Zs+E9LB=aiB5aUu0unfVW=2oA@mail.gmail.com>
Subject: Re: kernel BUG at drivers/gpu/drm/i915/i915_gem
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rocko Requin <rockorequin@hotmail.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:16, Rocko Requin <rockorequin@hotmail.com> wrote:
>> If you can wire up netconsole you should be able to gather the full
>> backtrace and that would be really useful. Otherwise can you please
>> confirm by reverting that commit from your current tree that it is
>> indeed the culprit? Otherwise please bisect the issue.
>
> I built 3.2-rc5 with the patch from commit
> eb1711bb94991e93669c5a1b5f84f11be2d51ea1 reversed, and have been using it
> now for a day and a half without any i915_gem issues. So at this stage it
> does seem likely it is the culprit, based on the fact that I had at least 2
> and probably 3 i915_gem crashes in around 12 hours with the commit applied.
> When I get some free time I'll reapply the patch and see if I can reproduce
> the crash and get a netconsole dump.

Backtraces from another reporter seriously look like we're hitting
some ugly use-after free. Can you please test whether the patch
"drm/i915: Only clear the GPU domains upon a successful finish" by
Chris Wilson fixes anything for you? You can grab it from
http://cgit.freedesktop.org/~danvet/drm/patch/?id=389a55581e30607af0fcde6cdb4e54f189cf46cf

Thanks, Daniel



-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
