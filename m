Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab2JXHpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:45:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34046 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806Ab2JXHpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:45:19 -0400
Date: Wed, 24 Oct 2012 09:45:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Michel Lespinasse <walken@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rbtree: include linux/compiler.h for definition of
 __always_inline
Message-ID: <20121024074513.GB25872@gmail.com>
References: <1350925287-15929-1-git-send-email-will.deacon@arm.com>
 <CANN689HrJMyQSXTjwJtMmyxJvccgMd-9EzRA-JsgDCp+STX6qw@mail.gmail.com>
 <20121023092927.GB19167@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023092927.GB19167@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> On Mon, Oct 22, 2012 at 10:56:21PM +0100, Michel Lespinasse wrote:
> > On Mon, Oct 22, 2012 at 10:01 AM, Will Deacon <will.deacon@arm.com> wrote:
> > > rb_erase_augmented is a static function annotated with __always_inline.
> > > This causes a compile failure when attempting to use the rbtree
> > > implementation as a library (e.g. kvm tool):
> > >
> > > rbtree_augmented.h:125:24: error: expected ???=???, ???,???, ???;???, ???asm??? or ???__attribute__??? before ???void???
> > >
> > > This patch includes linux/compiler.h in rbtree_augmented.h so that the
> > > __always_inline macro is resolved correctly.
> > >
> > > Cc: Pekka Enberg <penberg@kernel.org>
> > > Cc: Michel Lespinasse <walken@google.com>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > 
> > Just curious - what are you going to implement with augmented rbtrees
> > in kvm tool ?
> > 
> > If the basic rbtree or the interval tree implementations are
> > sufficient for your usage, you should try using that (in which case
> > you won't need this header fix).
> 
> kvm tool uses interval rbtrees for things like keeping track 
> of virtual devices, although it looks like Ingo implemented 
> the augment callbacks while moving to -rc1.

Yeah, latest kvmtool uses the modern augmented-rbtree facility 
of the kernel.

Thanks,

	Ingo
