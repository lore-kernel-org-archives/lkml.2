Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab1KRXS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:18:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51101 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1KRXSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
Date: Fri, 18 Nov 2011 15:18:23 -0800
X-Google-Sender-Auth: M4eJo--mzGwvzferO_DmH63ml0c
Message-ID: <CAGXu5jJk7uqDY1jkh-Sxz9iVk_rhmdoe7-4yc7QRCZEjrH7UOA@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] security: Yama LSM
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 8:17 PM, James Morris <jmorris@namei.org> wrote:
> On Wed, 26 Oct 2011, Kees Cook wrote:
>
>> As discussed at the Linux Security Summit, I'm resubmitting this
>> code. As an LSM, it has coherent policy around expanding specific DAC
>> behaviors. There is no need for it to be a full-blown MAC, since it is
>> not intended to be one, but rather to be a simplified expansion to DAC,
>> with system-wide knobs. See the specific patches for details...
>
> In principle, Yama can be merged, however there are features with
> unresolved upstream naks:
>
> - Handling symlinks in sticky directories

Also hardlink restrictions (disallow hardlinking to anything that a
user doesn't have read/write access to -- breaks no software, solves
actual vulnerabilities).

> - The ptrace tracker
>
> These still need to be resolved.

Hi Al,

I know you're not a fan of LSMs in general, but can you let Yama
extend DAC in these two cases (symlink and hardlink restrictions) for
the distros and admins that want these specific, decades-old,
well-established tweaks to how links work? Other LSMs handle policy
via these hooks, and Yama is just doing the same thing.

Thanks,

-Kees

-- 
Kees Cook
ChromeOS Security
