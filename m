Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1GUJse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:48:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:44335 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab1GUJsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:48:33 -0400
From: Richard Weinberger <richard@nod.at>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [uml-devel] [PATCH 09/10] um: Ajdust size of pid_buf
Date: Thu, 21 Jul 2011 11:48:31 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
References: <1311239914-8301-1-git-send-email-richard@nod.at> <1311239914-8301-9-git-send-email-richard@nod.at> <CAMuHMdUg6xCWFDkN0ApBhPE2Yw4gCcU2Aew60k8J-7oB518FAQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUg6xCWFDkN0ApBhPE2Yw4gCcU2Aew60k8J-7oB518FAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107211148.31290.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 21 Juli 2011, 11:38:11 schrieb Geert Uytterhoeven:
> On Thu, Jul 21, 2011 at 11:18, Richard Weinberger <richard@nod.at> wrote:
> > Linux can have pids up to 4*1024*1024.
> > To handle such huge numbers pid_buf needs to be larger.
> > 
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  arch/um/drivers/harddog_user.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/um/drivers/harddog_user.c
> > b/arch/um/drivers/harddog_user.c index b56f8e0..84dce3f 100644
> > --- a/arch/um/drivers/harddog_user.c
> > +++ b/arch/um/drivers/harddog_user.c
> > @@ -32,7 +32,7 @@ int start_watchdog(int *in_fd_ret, int *out_fd_ret,
> > char *sock) {
> >        struct dog_data data;
> >        int in_fds[2], out_fds[2], pid, n, err;
> > -       char pid_buf[sizeof("nnnnn\0")], c;
> > +       char pid_buf[sizeof("nnnnnnn\0")], c;
> 
> Why not make it handle the full 32-bit? That's just a few bytes extra
> on the stack...

True.
The sizeof("nnnnnnn\0") crap will anyway go away.
ASAP I'll submit a patch which removes all sizeof("nnnnnnn\0") and replaces
sprintf() with snprintf().

Thanks,
//richard
