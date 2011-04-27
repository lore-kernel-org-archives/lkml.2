Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab1D0QlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:41:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56029 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1D0QlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:41:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] x86-64: re-use kernel/syscall_table_32.S in ia32/ia32entry.S
Date: Wed, 27 Apr 2011 18:40:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
References: <4DB85376020000780003E6C9@vpn.id2.novell.com> <4DB83946.609@zytor.com> <4DB85A4F020000780003E6F7@vpn.id2.novell.com>
In-Reply-To: <4DB85A4F020000780003E6F7@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271840.32015.arnd@arndb.de>
X-Provags-ID: V02:K0:JFNETl47WGk5xepwyhLIDxm9cPYJx/cxbsWvsvNpub8
 /gS++9qjuOiX+rfybIn61lMo8HPlOaKfR4h+Th7lFOFl5YYTeS
 Lzy+NC00FxOXD2MG3tBaGvqaN85/Wz2bKArk/xkiw8vaCCwNfx
 6N70UO1o/ktNVqCTT4vz6T1tZCgVab24JX4laRNYlodj95tT2V
 9xqWtN/wtPbvzNmf4nTrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 18:02:55 Jan Beulich wrote:
> >>> On 27.04.11 at 17:41, "H. Peter Anvin" <hpa@zytor.com> wrote:
> > On 04/27/2011 08:33 AM, Jan Beulich wrote:
> >> This requires a little bit of renaming, and a (much shorter than the
> >> original full table) set of #define-s for those table entries where
> >> native and compat mode entries differ.
> >> 
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> > 
> > Hm... not 100% sure I think this is an improvement, partly because it
> > creates "action at a distance" -- you now have to look in two separate
> > places to find out what actually happens with a system call -- and
> > because the i386 table is already a bit of an "odd man out".  I would
> > much rather like to see a setup where you have __SYSCALL() macros in
> > unistd_64.h-style and perhaps augment it with a 3-operand __SYSCALL()
> > macro for the case where compat and non-compat are different.
> > 
> > What do you think?
> 
> Yes, that's certainly an alternative.

How about following the same style as asm-generic/unistd.h? It's
originally derived from the x86 version, but has added support for
compat syscalls for the tile architecture.

	Arnd
