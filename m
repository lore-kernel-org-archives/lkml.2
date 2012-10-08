Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab2JHPrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:47:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2JHPrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:47:20 -0400
Date: Mon, 8 Oct 2012 10:47:11 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        "Andrew G. Morgan" <morgan@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] proc: don't show nonexistent capabilities (v2)
Message-ID: <20121008154711.GA16261@sergelap>
References: <1349603814-1085468-1-git-send-email-avagin@openvz.org>
 <CAGXu5jL8VvfVu0XN7-HDwGt232ovvUBvjP5CJQt+6A3Jnv_OfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL8VvfVu0XN7-HDwGt232ovvUBvjP5CJQt+6A3Jnv_OfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> On Sun, Oct 7, 2012 at 2:56 AM, Andrew Vagin <avagin@openvz.org> wrote:
> > Without this patch it is really hard to interpret a bounding set,
> > if CAP_LAST_CAP is unknown for a current kernel.
> >
> > Non-existant capabilities can not be deleted from a bounding set
> > with help of prctl.
> >
> > E.g.: Here are two examples without/with this patch.
> > CapBnd: ffffffe0fdecffff
> > CapBnd: 00000000fdecffff
> >
> > I suggest to hide non-existent capabilities. Here is two reasons.
> > * It's logically and easier for using.
> > * It helps to checkpoint-restore capabilities of tasks, because tasks
> > can be restored on another kernel, where CAP_LAST_CAP is bigger.
> >
> > v2: Non-existent capabilities can not be removed from creds, because
> >     in this case user cannot set all=eip. This patch cleans up non-existent
> >     capabilities from content of /proc/pid/status
> >
> > Cc: Andrew G. Morgan <morgan@kernel.org>
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>

Basic capsh tests seem to have no problem with it.

Thanks, Andrew.

Reviewed-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> > Cc: Pavel Emelyanov <xemul@parallels.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Signed-off-by: Andrew Vagin <avagin@openvz.org>
> 
> Seems sensible to me.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> -Kees
> 
> -- 
> Kees Cook
> Chrome OS Security
