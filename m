Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2FNTrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 15:47:03 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:41216 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab2FNTrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:47:01 -0400
Date: Thu, 14 Jun 2012 21:47:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jim Cromie <jim.cromie@gmail.com>, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, bp@amd64.org, pawel.moll@arm.com,
        jbaron@redhat.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with
 initcall levels
Message-ID: <20120614194721.GA32312@aftab.osrc.amd.com>
References: <20120612105913.GA8404@aftab.osrc.amd.com>
 <1339699862-3731-1-git-send-email-jim.cromie@gmail.com>
 <1339701783.5981.5.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1339701783.5981.5.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 09:23:03PM +0200, Paul Bolle wrote:
> On Thu, 2012-06-14 at 12:51 -0600, Jim Cromie wrote:
> > main.c has initcall_level_names[] for parse_args to print in debug messages,
> > add comments to keep them in sync with initcalls defined in init.h.
> > Also tweak comment re not using *_initcall macros in loadable modules.
> > 
> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> > ---
> >  include/linux/init.h |    3 ++-
> >  init/main.c          |    1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/init.h b/include/linux/init.h
> > index 6b95109..da6f6f9 100644
> > --- a/include/linux/init.h
> > +++ b/include/linux/init.h
> > @@ -191,6 +191,7 @@ extern bool initcall_debug;
> >   * initializes variables that couldn't be statically initialized.
> >   *
> >   * This only exists for built-in code, not for modules.
> > + * Keep main.c:initcall_level_names[] in sync. */
> >   */
> 
> This comment now ends with "*/" twice. Perhaps that's legal

Of course it isn't, good catch Paul:

In file included from include/linux/printk.h:4:0,
                 from include/linux/kernel.h:22,
                 from include/asm-generic/bug.h:5,
                 from /usr/src/linux-2.6/arch/x86/include/asm/bug.h:38,
                 from include/linux/bug.h:4,
                 from include/linux/page-flags.h:9,
                 from kernel/bounds.c:9:
include/linux/init.h:195:3: error: expected identifier or ‘(’ before ‘/’ token
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2

Jim, you need to test-build your patches no matter how trivial they are.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
