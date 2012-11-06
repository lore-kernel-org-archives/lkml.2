Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2KFMy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:54:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234Ab2KFMyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:54:23 -0500
Date: Tue, 6 Nov 2012 07:54:17 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Only sign modules if built in-tree
Message-ID: <20121106125417.GI27352@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org>
 <87390t6bs0.fsf@rustcorp.com.au>
 <20121101112655.GM6627@hansolo.jdub.homelinux.org>
 <20121101145013.GN6627@hansolo.jdub.homelinux.org>
 <87liek4rt5.fsf@rustcorp.com.au>
 <20121102123404.GO6627@hansolo.jdub.homelinux.org>
 <87vcdkyfi4.fsf@rustcorp.com.au>
 <20121105191903.GG27352@hansolo.jdub.homelinux.org>
 <87a9uv5xbp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9uv5xbp.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 12:04:02PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> > On Mon, Nov 05, 2012 at 12:31:39PM +1030, Rusty Russell wrote:
> >> Josh Boyer <jwboyer@redhat.com> writes:
> >> > diff --git a/Makefile b/Makefile
> >> > index 14c93b3..7e27d51 100644
> >> > --- a/Makefile
> >> > +++ b/Makefile
> >> > @@ -722,8 +722,14 @@ export mod_strip_cmd
> >> >  ifeq ($(CONFIG_MODULE_SIG),y)
> >> >  MODSECKEY = ./signing_key.priv
> >> >  MODPUBKEY = ./signing_key.x509
> >> > +ifeq ($(KBUILD_EXTMOD),)
> >> > +SIGNFAIL = false
> >> > +else
> >> > +# External builds might not have a signing key, don't break module_install.
> >> > +SIGNFAIL = true
> >> > +endif # KBUILD_EXTMOD
> >> >  export MODPUBKEY
> >> > -mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> >> > +mod_sign_cmd = $(SIGNFAIL) || perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
> >> >  else
> >> >  mod_sign_cmd = true
> >> >  endif
> >> 
> >> Huh?  'true || perl' never runs perl due to short circuiting.
> >
> > Ah.  Maybe you were going for "sign all modules if keys are available,
> > but don't break external if they aren't" semantics.  I was just skipping
> > it entirely for external modules.
> 
> Exactly.  This way you get warnings, not failure.  You probably want
> that, since you'll (at least) taint your kernel when you load those
> modules.
> 
> I've applied this in my fixes branch, will push to Linus later this
> week.

Great.  Thanks Rusty!

josh
