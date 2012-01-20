Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2ATJWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 04:22:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54321 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031Ab2ATJWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 04:22:31 -0500
Date: Fri, 20 Jan 2012 09:22:22 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
Message-ID: <20120120092222.GA30612@arm.com>
References: <gi39bcyff8.fsf@mx10.gouders.net>
 <20120119110121.GC9268@arm.com>
 <gi1uqvsx8n.fsf@karga.hank.lab>
 <20120119140058.GA19036@arm.com>
 <gik44nrc52.fsf@karga.hank.lab>
 <20120119153732.GB20558@arm.com>
 <gi1uqvwpt2.fsf@mx10.gouders.net>
 <gimx9jv50u.fsf@mx10.gouders.net>
 <giipk7v2hv.fsf@mx10.gouders.net>
 <CA+5PVA67g_2u6YkYtOMKwZOzmmkHs7FhYUASSOQbDozFvrzp-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+5PVA67g_2u6YkYtOMKwZOzmmkHs7FhYUASSOQbDozFvrzp-A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 02:20:24AM +0000, Josh Boyer wrote:
> On Thu, Jan 19, 2012 at 3:52 PM, Dirk Gouders
> <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
> >> I did some more testing and it turns out that I have to revert a single
> >> line of commit b66930052abf2 to make the kernel boot:
> >>
> >> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> >> index c833add..d8bbb68 100644
> >> --- a/mm/kmemleak.c
> >> +++ b/mm/kmemleak.c
> >> @@ -1710,6 +1710,7 @@ static void kmemleak_disable(void)
> >>                 return;
> >>
> >>         /* stop any memory operation tracing */
> >> +       atomic_set(&kmemleak_early_log, 0);
> >>         atomic_set(&kmemleak_enabled, 0);
> >>
> >>         /* check whether it is too early for a kernel thread */
> >>
> >> I started that kernel with initcall_debug and attach the dmesg output.
> >
> > Hi Catlin,
> >
> > I want to note that in my config CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is
> > set which causes kmemleak_disable() to be called in kmemleak_init().
> 
> I also had CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y in my .config.  Disabling that
> option allowed the machine to boot just fine.  Dirk seems to be onto something
> here.

It definitely looks like a kmemleak problem with
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y. I managed to reproduce it on ARM as
well.

I'll have a look and get back shortly.

Thanks.

-- 
Catalin
