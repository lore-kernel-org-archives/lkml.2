Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0F2TCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:02:45 -0400
Received: from mail.perches.com ([173.55.12.10]:1404 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070Ab0F2TCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:02:44 -0400
Subject: Re: [PATCH] arch/x86/kernel/cpu/mtrr/cleanup.c: Use ";" not "," to
 terminate statements
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100629001431.GC12255@elte.hu>
References: <1277768808.29157.280.camel@Joe-Laptop.home>
	 <20100629001431.GC12255@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Jun 2010 12:02:41 -0700
Message-ID: <1277838161.15226.11.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 02:14 +0200, Ingo Molnar wrote:
> * Joe Perches <joe@perches.com> wrote:
> 
> > Needed if pr_<level> becomes a bit more space efficient.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
> > index 06130b5..c5f59d0 100644
> > --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> > +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> > @@ -632,9 +632,9 @@ static void __init mtrr_print_out_one_result(int i)
> >  	unsigned long gran_base, chunk_base, lose_base;
> >  	char gran_factor, chunk_factor, lose_factor;
> >  
> > -	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor),
> > -	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor),
> > -	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor),
> > +	gran_base = to_size_factor(result[i].gran_sizek, &gran_factor);
> > +	chunk_base = to_size_factor(result[i].chunk_sizek, &chunk_factor);
> > +	lose_base = to_size_factor(result[i].lose_cover_sizek, &lose_factor);
> 
> That file and this subsystem needs a lot more cleanups than just this. Would 
> you be willing to do them all, so that we can get over with the churn in a 
> single well-defined patch (or patches)?
> 
> I dont see much point in piecemail single-comma patches - i'd rather wait for 
> someone else who'd fix this and other details in one go.

This is the only "," preceeding a pr_<level> printk
in the kernel tree.

The comma prevents the pr_<level> macro to take the
"do { foo } while (0)" form.

I don't see significant issues in the code style that
need cleanups in arch/x86/kernel/cpu/mtrr.

What do you think needs cleaning?


