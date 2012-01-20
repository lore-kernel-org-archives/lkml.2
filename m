Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2ATOWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 09:22:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62158 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab2ATOWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 09:22:11 -0500
Date: Fri, 20 Jan 2012 14:21:38 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
Message-ID: <20120120142138.GD30612@arm.com>
References: <20120119110121.GC9268@arm.com>
 <gi1uqvsx8n.fsf@karga.hank.lab>
 <20120119140058.GA19036@arm.com>
 <gik44nrc52.fsf@karga.hank.lab>
 <20120119153732.GB20558@arm.com>
 <gi1uqvwpt2.fsf@mx10.gouders.net>
 <gimx9jv50u.fsf@mx10.gouders.net>
 <giipk7v2hv.fsf@mx10.gouders.net>
 <20120120110111.GB30612@arm.com>
 <CA+5PVA6WOVCAaAWmSZy6GhU+a-0Hy29W1_awAEWkdusYxkN3Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA6WOVCAaAWmSZy6GhU+a-0Hy29W1_awAEWkdusYxkN3Eg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 02:16:49PM +0000, Josh Boyer wrote:
> On Fri, Jan 20, 2012 at 6:01 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Jan 19, 2012 at 08:52:44PM +0000, Dirk Gouders wrote:
> >> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:
> >> I want to note that in my config CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is
> >> set which causes kmemleak_disable() to be called in kmemleak_init().
> >
> > Thanks for the investigation. Could you please try the patch below?
> > Thanks.
> >
> >
> > From 09e7bd41ff3fd07e4c5eea7bbb0a045921eb5944 Mon Sep 17 00:00:00 2001
> > From: Catalin Marinas <catalin.marinas@arm.com>
> > Date: Fri, 20 Jan 2012 10:42:40 +0000
> > Subject: [PATCH] kmemleak: Disable early logging when kmemleak is off by
> >  default
> >
> > Commit b6693005 (kmemleak: When the early log buffer is exceeded, report
> > the actual number) deferred the disabling of the early logging to
> > kmemleak_init(). However, when CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y, the
> > early logging was no longer disabled causing __init kmemleak functions
> > to be called even after the kernel freed the init memory. This patch
> > disables the early logging during kmemleak_init() if kmemleak is left
> > disabled.
> >
> > Reported-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I tested this on my machine and it works for me as well.  Thanks for the quick
> turn around.  Feel free to add a:
> 
> Tested-by: Josh Boyer <jwboyer@gmail.com>

Thanks to both of you.

-- 
Catalin
