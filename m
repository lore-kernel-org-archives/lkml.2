Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1H2Ruv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:50:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48217 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab1H2Rut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:50:49 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, David Airlie <airlied@redhat.com>,
        Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Date: Mon, 29 Aug 2011 19:50:34 +0200
In-Reply-To: <20110829171750.GD2025@gere.osrc.amd.com>
References: <20110829141612.GB2025@gere.osrc.amd.com>
	 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	 <20110829155501.GC2025@gere.osrc.amd.com>
	 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
	 <20110829171750.GD2025@gere.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314640234.2816.118.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 19:17 +0200, Borislav Petkov wrote:
> On Mon, Aug 29, 2011 at 12:10:45PM -0400, Arnaud Lacombe wrote:
> > do you want something ala:
> > 
> > config EXTRA_FIRMWARE
> >     string
> >     default ""
> >     append "FOO" if BAR
> >     append "FOZ" if BAZ
> > 
> > or maybe a new type "list" which would behave as a comma/space separated value.
> > 
> > config EXTRA_FIRMWARE
> >     list "bla"
> >     append "FOO" if BAR
> >     append "FOZ" if BAZ
> 
> Yeah, actually Kyle's note (http://lkml.org/lkml/2011/8/29/289) makes
> much more sense for linux and the whole firmware in the kernel deal.
> So it looks like the drivers should be taught to wait for userspace to
> appear instead of Kconfig helping them build-in firmware. And then we
> should go ahead and remove CONFIG_EXTRA_FIRMWARE completely...

That would suck, suppose this radeon thing is the only console you've
got (ppc64/sparc64 don't have text mode iirc) and userspace doesn't come
up?


