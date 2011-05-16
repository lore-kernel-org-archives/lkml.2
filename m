Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1EPOoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:44:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:55767 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755525Ab1EPOoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:44:15 -0400
Date: Mon, 16 May 2011 16:44:13 +0200
From: Michal Marek <mmarek@suse.cz>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: make KBUILD_NOCMDDEP=1 handle empty built-in.o
Message-ID: <20110516144413.GN13293@sepie.suse.cz>
References: <1303837564-18062-1-git-send-email-rabin@rab.in>
 <BANLkTimLre+UY1fY6+HXEsJicyh_oMnWdA@mail.gmail.com>
 <20110512133356.GI13293@sepie.suse.cz>
 <BANLkTiktdW3N35YYDB6dmUOMG1ZbQpYrow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTiktdW3N35YYDB6dmUOMG1ZbQpYrow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 11:07:19PM +0530, Rabin Vincent wrote:
> On Thu, May 12, 2011 at 19:03, Michal Marek <mmarek@suse.cz> wrote:
> > I'm not sure if this is the rigt way to fix it. Kbuild.include should
> > not care about obj-*. The problem is that arg-check is always empty with
> > KBUILD_NOCMDDEP and if there are no other dependencies, the target will
> > not be created, right? IMO we only need to make sure that during the
> > first make run, arg-check always expands to non-empty, even with
> > KBUILD_NOCMDDEP. So we can drop the $(obj-y) test and do it like this
> > (untested), can't we?
> >
> > diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
> > index c034dd7..be39cd1 100644
> > --- a/scripts/Kbuild.include
> > +++ b/scripts/Kbuild.include
> > @@ -197,6 +197,8 @@ ifneq ($(KBUILD_NOCMDDEP),1)
> >  # User may override this check using make KBUILD_NOCMDDEP=1
> >  arg-check = $(strip $(filter-out $(cmd_$(1)), $(cmd_$@)) \
> >                     $(filter-out $(cmd_$@),   $(cmd_$(1))) )
> > +else
> > +arg-check = $(if $(strip $(cmd_$@)),,1)
> >  endif
> >
> >  # >'< substitution is for echo to work,
> 
> This works for me, thanks.
> 
> Tested-by: Rabin Vincent <rabin@rab.in>

Thanks, pushed to kbuild-2.6.git#kbuild.

Michal
