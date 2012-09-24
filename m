Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2IXIAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 04:00:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53898 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab2IXIAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 04:00:03 -0400
Date: Mon, 24 Sep 2012 09:59:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: Franklin Wei <frankhwei536@gmail.com>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: arch/x86/lib/inat.c Error
Message-ID: <20120924075957.GA5151@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Franklin Wei <frankhwei536@gmail.com>, linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@redhat.com>
References: <CAEMuUziMGAM4UOeOGWwG9jiceU9K7NSzqbryMxHwFDfmOfqQdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEMuUziMGAM4UOeOGWwG9jiceU9K7NSzqbryMxHwFDfmOfqQdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2012 at 04:34:24PM -0400, Franklin Wei wrote:
> Something wrong with lines 29-86
> Error message when compiling:
>   CC      arch/x86/lib/inat.o
> arch/x86/lib/inat.c: In function ‘inat_get_opcode_attribute’:
> arch/x86/lib/inat.c:29: error: ‘inat_primary_table’ undeclared (first
> use in this function)
> arch/x86/lib/inat.c:29: error: (Each undeclared identifier is reported only once
> arch/x86/lib/inat.c:29: error: for each function it appears in.)
> arch/x86/lib/inat.c: In function ‘inat_get_escape_attribute’:
> arch/x86/lib/inat.c:48: error: ‘inat_escape_tables’ undeclared (first
> use in this function)
> arch/x86/lib/inat.c: In function ‘inat_get_group_attribute’:
> arch/x86/lib/inat.c:67: error: ‘inat_group_tables’ undeclared (first
> use in this function)
> arch/x86/lib/inat.c: In function ‘inat_get_avx_attribute’:
> arch/x86/lib/inat.c:86: error: ‘inat_avx_tables’ undeclared (first use
> in this function)
> make[1]: *** [arch/x86/lib/inat.o] Error 1
> make: *** [arch/x86/lib] Error 2

That's because all those _tables thingies are included from a
"inat-tables.c" in the same directory but it somehow doesn't get
included?!

Can we get your .config pls? Also, you're doing a "normal" kernel build
on the command line, right?

Thanks.

-- 
Regards/Gruss,
    Boris.
