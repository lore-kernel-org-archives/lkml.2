Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1BIO7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 09:59:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35937 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab1BIO7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 09:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PEXawi2ox1Yl0eaKpkOQhXvBrQP+vPRAfTInM/n6beAhFKP4M+A02A8TesELk7N3Od
         GixcsPMXnuWGDcgRZ+FWIFj9QR1ajp0l4nX4ZOUkUFR0fJ9hidmv0P6MDrzFOZUqixUE
         IlHaUiy3F5ye0bI+CrEjoWNiLOQDM7kKmItDQ=
MIME-Version: 1.0
In-Reply-To: <m1bp2ly41q.fsf@fess.ebiederm.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
Date: Wed, 9 Feb 2011 15:59:20 +0100
Message-ID: <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
From: Alex Riesen <raa.lkml@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 10:01, Eric W. Biederman <ebiederm@xmission.com> wrote:
> The failures look like:
>
> $ make -C gcc-stage1-x86_64 all-gcc all-target-libgcc install-gcc install-target-libgcc DESTDIR=/bld/Across/Across-2.0.0/sysroot-x86_64
> gcc -qlanglvl=ansi -c -DHAVE_CONFIG_H -g -O2 -I. -I/bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/../include  -W -Wall
> -Wwrite-strings -Wc++-compat -Wstrict-prototypes /bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c -o fibheap.o
> gcc: unrecognized option '-qlanglvl=ansi'
> /bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c: In function ‘fibheap_union’:
> /bld/Across/Across-2.0.0/gcc-4.4.3/libiberty/fibheap.c:151: warning: implicit declaration of function ‘free’

Maybe some files (stdlib.h or malloc.h) return no data when read?
Then, gcc still
"compiles" them, but all the declarations are missing. And I would expect gcc
to complain if zero blocks returned, and truncated files are very likely to
abort compilation.

Can the command be strace'd immediately after the failure?
