Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab2JWJ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:29:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55758 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932792Ab2JWJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:29:40 -0400
Date: Tue, 23 Oct 2012 10:29:27 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michel Lespinasse <walken@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] rbtree: include linux/compiler.h for definition of
 __always_inline
Message-ID: <20121023092927.GB19167@mudshark.cambridge.arm.com>
References: <1350925287-15929-1-git-send-email-will.deacon@arm.com>
 <CANN689HrJMyQSXTjwJtMmyxJvccgMd-9EzRA-JsgDCp+STX6qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANN689HrJMyQSXTjwJtMmyxJvccgMd-9EzRA-JsgDCp+STX6qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:56:21PM +0100, Michel Lespinasse wrote:
> On Mon, Oct 22, 2012 at 10:01 AM, Will Deacon <will.deacon@arm.com> wrote:
> > rb_erase_augmented is a static function annotated with __always_inline.
> > This causes a compile failure when attempting to use the rbtree
> > implementation as a library (e.g. kvm tool):
> >
> > rbtree_augmented.h:125:24: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
> >
> > This patch includes linux/compiler.h in rbtree_augmented.h so that the
> > __always_inline macro is resolved correctly.
> >
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: Michel Lespinasse <walken@google.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> Just curious - what are you going to implement with augmented rbtrees
> in kvm tool ?
> 
> If the basic rbtree or the interval tree implementations are
> sufficient for your usage, you should try using that (in which case
> you won't need this header fix).

kvm tool uses interval rbtrees for things like keeping track of virtual
devices, although it looks like Ingo implemented the augment callbacks
while moving to -rc1.

> But either way, the header fix is correct and will be required when
> someone wants to use augmented rbtrees outside of the kernel. I just
> didn't think that day would come so fast :)
> 
> Reviewed-by: Michel Lespinasse <walken@google.com>

Thanks Michel!

Will
