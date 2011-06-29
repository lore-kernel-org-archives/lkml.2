Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab1F2Pmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:42:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:45127 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1F2Pmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:42:32 -0400
From: Richard Weinberger <richard@nod.at>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Subject: Re: [PATCH 1/4] um: Fix _FORTIFY_SOURCE=2 support for kernel modules
Date: Wed, 29 Jun 2011 17:42:23 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
References: <1309212931-19772-1-git-send-email-richard@nod.at> <BANLkTikauFJtuCo5E3=tb_=cwVS3sF35zw@mail.gmail.com>
In-Reply-To: <BANLkTikauFJtuCo5E3=tb_=cwVS3sF35zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291742.24137.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 29 Juni 2011, 17:37:54 schrieb Vitaliy Ivanov:
> On Tue, Jun 28, 2011 at 1:15 AM, Richard Weinberger <richard@nod.at> wrote:
> > When UML is compiled with _FORTIFY_SOURCE we have to
> > export all _chk() functions which are used in modules.
> > For now it's only the case for __sprintf_chk().
> > 
> > Tested-by: Florian Fainelli <florian@openwrt.org>
> > Reported-by: Florian Fainelli <florian@openwrt.org>
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  arch/um/os-Linux/user_syms.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/um/os-Linux/user_syms.c b/arch/um/os-Linux/user_syms.c
> > index 05f5ea8..45ffe46 100644
> > --- a/arch/um/os-Linux/user_syms.c
> > +++ b/arch/um/os-Linux/user_syms.c
> > @@ -113,3 +113,8 @@ EXPORT_SYMBOL(__stack_smash_handler);
> > 
> >  extern long __guard __attribute__((weak));
> >  EXPORT_SYMBOL(__guard);
> > +
> > +#ifdef _FORTIFY_SOURCE
> > +extern int __sprintf_chk(char *str, int flag, size_t strlen, const char
> > *format); +EXPORT_SYMBOL(__sprintf_chk);
> > +#endif
> > --
> 
> Can you please clarify why it's needed? I use FORTIFY_SOURCES on
> Linus' tree UML on Ubuntu w/ no problems and w/o this patch...

The problem appears only when a UML kernel module is using sprintf().
E.g: CONFIG_UML_WATCHDOG.
Then loading the module will fail because of the missing symbol __sprintf_chk().

Thanks,
//richard
