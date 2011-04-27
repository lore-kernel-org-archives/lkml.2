Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1D0Pm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:42:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41463 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1D0Pm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:42:27 -0400
Message-ID: <4DB83946.609@zytor.com>
Date: Wed, 27 Apr 2011 08:41:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110422 Fedora/3.1.9-7.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: re-use kernel/syscall_table_32.S in	 ia32/ia32entry.S
References: <4DB85376020000780003E6C9@vpn.id2.novell.com>
In-Reply-To: <4DB85376020000780003E6C9@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2011 08:33 AM, Jan Beulich wrote:
> This requires a little bit of renaming, and a (much shorter than the
> original full table) set of #define-s for those table entries where
> native and compat mode entries differ.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Hm... not 100% sure I think this is an improvement, partly because it
creates "action at a distance" -- you now have to look in two separate
places to find out what actually happens with a system call -- and
because the i386 table is already a bit of an "odd man out".  I would
much rather like to see a setup where you have __SYSCALL() macros in
unistd_64.h-style and perhaps augment it with a 3-operand __SYSCALL()
macro for the case where compat and non-compat are different.

What do you think?

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

