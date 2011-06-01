Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865Ab1FALyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:54:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63426 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab1FALyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KDDsAqN7rc/tA+ZJx1c2WJzEXeAduYmGoKzVi8CnHL/6V5YkbWGCKaOimq+NDC4R05
         r5sY8i90q+YD5IUJhOd7IOXBwr6W3prY5LHCUVXS/1QvdUlgyT8NIgcIEOEB3AgYuCka
         DQZ4KJROD8pPGq3IFR5vdwee33vUTimzNHH7E=
MIME-Version: 1.0
In-Reply-To: <06958cd58d0de8b0c674c9b3fa37f9a297ee90f2.1306847455.git.luto@mit.edu>
References: <cover.1306847455.git.luto@mit.edu>
	<06958cd58d0de8b0c674c9b3fa37f9a297ee90f2.1306847455.git.luto@mit.edu>
Date: Wed, 1 Jun 2011 07:54:22 -0400
Message-ID: <BANLkTi=FCwtiyRGEuueD_vP+BLHHPzCpBw@mail.gmail.com>
Subject: Re: [PATCH v3 08/10] x86-64: Emulate legacy vsyscalls
From: Brian Gerst <brgerst@gmail.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 9:16 AM, Andy Lutomirski <luto@mit.edu> wrote:
> There's a fair amount of code in the vsyscall page.  It contains a
> syscall instruction (in the gettimeofday fallback) and who knows
> what will happen if an exploit jumps into the middle of some other
> code.
>
> Reduce the risk by replacing the vsyscalls with short magic
> incantations that cause the kernel to emulate the real vsyscalls.
> These incantations are useless if entered in the middle.

How about remapping the vsyscall page into a random page in the
modules area, and make the fixed page simply have stubs that jump to
the code in that page.  That would solve the fixed address syscall
problem without any more overhead.

--
Brian Gerst
