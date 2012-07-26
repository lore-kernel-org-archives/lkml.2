Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2GZMUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:20:43 -0400
Received: from osrc3.amd.com ([217.9.48.20]:40962 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab2GZMUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:20:23 -0400
Date: Thu, 26 Jul 2012 14:20:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device
 lifetime
Message-ID: <20120726122016.GD30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-9-git-send-email-ming.lei@canonical.com>
 <20120725160425.GK11152@aftab.osrc.amd.com>
 <CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 10:59:08AM +0800, Ming Lei wrote:
> On Thu, Jul 26, 2012 at 12:04 AM, Borislav Petkov <bp@amd64.org> wrote:
> >> Also this patch holds the reference cound of @device before
> >
> >                                         count
> 
> Good catch, will fix it in -v1.
> 
> 
> >> - *   it is not possible to sleep for long time. It can't be called
> >> - *   in atomic contexts.
> >> + *   it is not possible to sleep for long time.
> >
> > Let's state it explicitly:
> >
> >         "it is not allowed to sleep for it is called in atomic context."
> 
> Looks you understand it incorrectly, the sentence is below
> 
>  *      Asynchronous variant of request_firmware() for user contexts where
>  *      it is not possible to sleep for long time.
> 
> and maybe it should be changed to below:
> 
>  *      Asynchronous variant of request_firmware() for user contexts where
>  *      it is not possible to sleep for long time or can't sleep at all.

Ok, here's what I got from looking at the patch:

Your commit message says: "Also request_firmware_nowait should be called
in atomic context now, so fix the obsolete comments."

Atomic context in my book means you're not allowed to sleep at all.

But the comment says that it is possible to sleep a little. This is very
wrongly formulated AFAICT.

But, since request_firmware_nowait receives a GFP mask as one of its
arguments and some of its callers don't supply GFP_ATOMIC then this
has nothing to do with atomic contexts at all. Then, you should simply
explain in the comment why exactly callers aren't allowed to be sleeping
for a long time. And using adjectives like "long" or "short" is very
misleading in such explanations so please be more specific as to why the
callers shouldn't be sleeping for extended periods of time.

I hope I'm making sense here...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
