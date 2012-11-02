Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964Ab2KBEZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 00:25:23 -0400
Received: from ozlabs.org ([203.10.76.45]:45298 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KBEZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 00:25:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Bruno Wolff III <bruno@wolff.to>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Only sign modules if built in-tree
In-Reply-To: <20121101145013.GN6627@hansolo.jdub.homelinux.org>
References: <20121031132749.GH6627@hansolo.jdub.homelinux.org> <87390t6bs0.fsf@rustcorp.com.au> <20121101112655.GM6627@hansolo.jdub.homelinux.org> <20121101145013.GN6627@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 02 Nov 2012 13:47:10 +1030
Message-ID: <87liek4rt5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:

> On Thu, Nov 01, 2012 at 07:26:55AM -0400, Josh Boyer wrote:
>> > I prefer something like this (untested):
>> > 
>> > diff --git a/Makefile b/Makefile
>> > index 42d0e56..cb66c8d 100644
>> > --- a/Makefile
>> > +++ b/Makefile
>> > @@ -722,8 +722,14 @@ export mod_strip_cmd
>> >  ifeq ($(CONFIG_MODULE_SIG),y)
>> >  MODSECKEY = ./signing_key.priv
>> >  MODPUBKEY = ./signing_key.x509
>> > +ifeq ($(KBUILD_EXTMOD),)
>> > +SIGNFAIL = false
>> > +else
>> > +# External builds might not have a signing key, don't break module_install.
>> > +SIGNFAIL = true
>> > +endif # KBUILD_EXTMOD
>> >  export MODPUBKEY
>> > -mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
>> > +mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY) || $(SIGNFAIL)
>> >  else
>> >  mod_sign_cmd = true
>> >  endif
>> 
>> OK.  I'll give this a spin locally today, but at first glance it seems
>> like it would do the same.
>
> We need to put $(SIGNFAIL) before the perl script invocation or we get
> errors because mod_sign_cmd is passed an argument and sign-file is
> treating the "|| $(SIGNFAIL)" as something it's passed.  That was the
> only change I needed to make and it works as expected.
>
> Do you want me to send a v2 of the patch, or will you add it yourself
> given you've basically written the code?  Either way works for me.

Please re-submit.

Thanks,
Rusty.
