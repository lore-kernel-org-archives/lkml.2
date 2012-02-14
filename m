Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab2BNS7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:59:04 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48291 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2BNS7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:59:01 -0500
MIME-Version: 1.0
In-Reply-To: <4F32E98F.2090909@zytor.com>
References: <4F32A98F.7030400@zytor.com>
	<1328677745-20121-22-git-send-email-hpa@zytor.com>
	<1328677745-20121-1-git-send-email-hpa@zytor.com>
	<8328.1328703626@redhat.com>
	<16325.1328736262@redhat.com>
	<4F32E98F.2090909@zytor.com>
Date: Tue, 14 Feb 2012 10:59:00 -0800
X-Google-Sender-Auth: p687YD7eg6VTnzQogoUhu3mdMVE
Message-ID: <CA+8MBb+rMJqJAyDnnkB=x794F3MAQJfwTi29=4oN4-6=g5uDFw@mail.gmail.com>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
From: Tony Luck <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parts 1, 2 and 9 work fine on ia64 - consider them: Acked-by: Tony
Luck <tony.luck@intel.com>

This part causes build problems (starting with):


  CC      arch/ia64/kernel/asm-offsets.s
In file included from include/linux/timex.h:56,
                 from include/linux/sched.h:57,
                 from arch/ia64/kernel/asm-offsets.c:9:
include/linux/time.h: In function ‘__FD_ZERO’:
include/linux/time.h:280: error: implicit declaration of function ‘memset’
include/linux/time.h:280: warning: incompatible implicit declaration
of built-in function ‘memset’

Adding a #include <linux/string.h> to include/linux/time.h fixes them for me.

-Tony
