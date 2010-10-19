Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0JSEwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 00:52:35 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33160 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0JSEwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 00:52:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FfaJ6D435vbYnSERPqhEHs/LVTOEalhwfGv0/UJRT7xnt7gvDwqUIcJ/Mkm1XIbRGI
         28efgywlxQ4rBX9qAFEa53To8fwhsRqdmPfHU+HWvSSt5F10eMqhnhA+Nbi8TjWfZp3W
         gISZA8qDAmXN0PDc5jKavS1Znw9RAqyp6FE2U=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1010182342120.31740@banach.math.auburn.edu>
References: <201009161632.59210.arnd@arndb.de>
	<201010181742.06678.arnd@arndb.de>
	<20101018184346.GD27089@kroah.com>
	<AANLkTin2KPNNXvwcWphhM-5qexB14FS7M7ezkCCYCZ2H@mail.gmail.com>
	<20101019004004.GB28380@kroah.com>
	<AANLkTi=ffaihP5-yNYFKAbAbX+XbRgWRXXfCZd4J3KwQ@mail.gmail.com>
	<20101019022413.GB30307@kroah.com>
	<AANLkTinv4VFpi=Jkc_5oyFgPbdLRg0ResJx9u9Puhm-7@mail.gmail.com>
	<1287459219.16971.352.camel@gandalf.stny.rr.com>
	<alpine.LNX.2.00.1010182342120.31740@banach.math.auburn.edu>
Date: Tue, 19 Oct 2010 14:52:32 +1000
Message-ID: <AANLkTi=oAeuz8ZxcOMpf=3MVY=WMt0BwHiGCUxO7OAEV@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Dave Airlie <airlied@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Greg KH <greg@kroah.com>,
        codalist@telemann.coda.cs.cmu.edu, autofs@linux.kernel.org,
        Samuel Ortiz <samuel@sortiz.org>, Jan Kara <jack@suse.cz>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        Arnd Bergmann <arnd@arndb.de>, Jan Harkes <jaharkes@cs.cmu.edu>,
        netdev@vger.kernel.org, Anders Larsen <al@alarsen.net>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        Christoph Hellwig <hch@infradead.org>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Petr Vandrovec <vandrove@vc.cvut.cz>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-fsdevel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Ingo Molnar <mingo@elte.hu>, Andrew Hendry <andrew.hendry@gmail.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I might be able to find some hardware still lying around here that uses an
> i810. Not sure unless I go hunting it. But I get the impression that if
> the kernel is a single-CPU kernel there is not any problem anyway? Don't
> distros offer a non-smp kernel as an installation option in case the user
> needs it? So in reality how big a problem is this?

Not anymore, which is my old point of making a fuss. Nowadays in the
modern distro world, we supply a single kernel that can at runtime
decide if its running on SMP or UP and rewrite the text section
appropriately with locks etc. Its like magic, and something like
marking drivers as BROKEN_ON_SMP at compile time is really wrong when
what you want now is a runtime warning if someone tries to hotplug a
CPU with a known iffy driver loaded or if someone tries to load the
driver when we are already in SMP mode.

Dave.
