Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1FGDh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 23:37:29 -0400
Received: from mail.perches.com ([173.55.12.10]:2577 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1FGDh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 23:37:28 -0400
Subject: Re: [PATCH 8/8] arch/x86: use printk_ratelimited instead of
 printk_ratelimit
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        John Stultz <johnstul@us.ibm.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, trivial@kernel.org
In-Reply-To: <87mxhugwu1.fsf@rustcorp.com.au>
References: <cover.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
	 <fce87f1efab55e15e91b21f1b73f0e86016a27d9.1307199715.git.christian.dietrich@informatik.uni-erlangen.de>
	 <874o43ii1m.fsf@rustcorp.com.au>
	 <BANLkTinS67qH-pm2=Z9G1UXk4OOuZNsN9g@mail.gmail.com>
	 <87mxhugwu1.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:37:25 -0700
Message-ID: <1307417845.4994.57.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-07 at 12:41 +0930, Rusty Russell wrote:
> On Mon, 6 Jun 2011 10:11:53 +0200, richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
> > printk_ratelimited() needs DEFINE_RATELIMIT_STATE() which is defined
> > in ratelimit.h.
> Yech.  I'm assuming that making printk.h include ratelimit.h makes a
> nasty mess?

Yup.

I proposed moving the <foo>_ratelimited dclarations to
ratelimited.h without any comment.

http://lkml.org/lkml/2010/2/18/377

