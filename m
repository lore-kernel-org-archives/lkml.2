Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2FTB23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 21:28:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41979 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2FTB21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 21:28:27 -0400
Date: Tue, 19 Jun 2012 18:25:41 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: Constify 'type' argument for the registration
 routine
Message-ID: <20120620012541.GA3564@lizard>
References: <1339995037-19561-1-git-send-email-cbouatmailru@gmail.com>
 <20120619171128.377fc971.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120619171128.377fc971.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 05:11:28PM -0700, Andrew Morton wrote:
> On Sun, 17 Jun 2012 21:50:37 -0700
> Anton Vorontsov <anton.vorontsov@linaro.org> wrote:
> 
> > thermal_zone_device_register() does not modify 'type' argument, so
> > it is safe to declare it as const. Otherwise, if we pass a const
> > string, we are getting the ugly warning:
> > 
> > ...
> >
> 
> For some reason I can't apply this.

The reason is the same patch in ACPI tree that "broke" battery tree;
we're just touching the same lines of code and that causes some pain.

> I typed it in again and it seems
> to work OK.  I'll assume that someone else will merge it into
> whatever-tree-broke.

Len, will you merge this patch? Or should I take it into battery
tree? (If I'm taking it, then Stephen will have to resolve some
conflicts upon next -next tree generation.)

> > +struct thermal_zone_device *
> > +thermal_zone_device_register(const char *, int, void *,
> >  		const struct thermal_zone_device_ops *, int tc1, int tc2,
> >  		int passive_freq, int polling_freq);
> >  void thermal_zone_device_unregister(struct thermal_zone_device *);
> 
> Personally, I prefer it when the arguments are named in the declaration
> - if you ever have reason to *read* the thing, the lack of names is
> quite maddening.  Particularly when the function has 72 arguments.

:-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
