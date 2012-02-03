Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2BCGqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:46:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab2BCGqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:46:35 -0500
From: DJ Delorie <dj@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ia64@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        dsterba@suse.cz, ptesarik@suse.cz, rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
References: <20120201151918.GC16714@quack.suse.cz>
Date: Fri, 03 Feb 2012 01:45:42 -0500
In-Reply-To: <20120201151918.GC16714@quack.suse.cz> (Jan Kara's message of
	"Wed, 1 Feb 2012 16:19:18 +0100")
Message-ID: <xnbopg8lex.fsf@greed.delorie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jan Kara <jack@suse.cz> writes:
>   we've spotted the following mismatch between what kernel folks expect
> from a compiler and what GCC really does, resulting in memory corruption on
> some architectures. Consider the following structure:
> struct x {
>     long a;
>     unsigned int b1;
>     unsigned int b2:1;
> };

If this structure were volatile, you could try
-fstrict-volatile-bitfields, which forces GCC to use the C type to
define the access width, instead of doing whatever it thinks is optimal.

Note: that flag is enabled by default for some targets already, most
notably ARM.
