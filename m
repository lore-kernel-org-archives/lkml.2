Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab1KAXWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:22:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab1KAXWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:22:34 -0400
Date: Wed, 2 Nov 2011 00:22:33 +0100
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target
 list
Message-ID: <20111101232233.GA32441@sepie.suse.cz>
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com>
 <4E69FEC9.2080204@suse.cz>
 <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 01:17:10AM -0400, Arnaud Lacombe wrote:
> 2011/9/9 Michal Marek <mmarek@suse.cz>:
> > On 25.8.2011 03:03, Arnaud Lacombe wrote:
> >> +always += missing-syscalls
> >> +targets += missing-syscalls
> >> +
> >>  quiet_cmd_syscalls = CALL    $<
> >>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
> >
> > checksyscalls.sh needs to depend on generated/asm-offsets.h, otherwise a
> > parallel build will fail.
> >
> true.
> 
> This:
> 
> diff --git a/Kbuild b/Kbuild
> index 1a2eb32..4caab4f 100644
> --- a/Kbuild
> +++ b/Kbuild
> @@ -94,7 +94,7 @@ targets += missing-syscalls
>  quiet_cmd_syscalls = CALL    $<
>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
> 
> -missing-syscalls: scripts/checksyscalls.sh FORCE
> +missing-syscalls: scripts/checksyscalls.sh $(offsets-file) FORCE
>         $(call cmd,syscalls)

OK, applied to kbuild/kbuild with this fixup.

Michal
