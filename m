Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2JVV4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:56:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49840 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2JVV4X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:56:23 -0400
MIME-Version: 1.0
In-Reply-To: <1350925287-15929-1-git-send-email-will.deacon@arm.com>
References: <1350925287-15929-1-git-send-email-will.deacon@arm.com>
Date: Mon, 22 Oct 2012 14:56:21 -0700
Message-ID: <CANN689HrJMyQSXTjwJtMmyxJvccgMd-9EzRA-JsgDCp+STX6qw@mail.gmail.com>
Subject: Re: [PATCH] rbtree: include linux/compiler.h for definition of __always_inline
From: Michel Lespinasse <walken@google.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 10:01 AM, Will Deacon <will.deacon@arm.com> wrote:
> rb_erase_augmented is a static function annotated with __always_inline.
> This causes a compile failure when attempting to use the rbtree
> implementation as a library (e.g. kvm tool):
>
> rbtree_augmented.h:125:24: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘void’
>
> This patch includes linux/compiler.h in rbtree_augmented.h so that the
> __always_inline macro is resolved correctly.
>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Will Deacon <will.deacon@arm.com>

Just curious - what are you going to implement with augmented rbtrees
in kvm tool ?

If the basic rbtree or the interval tree implementations are
sufficient for your usage, you should try using that (in which case
you won't need this header fix).

But either way, the header fix is correct and will be required when
someone wants to use augmented rbtrees outside of the kernel. I just
didn't think that day would come so fast :)

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
