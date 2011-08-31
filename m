Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1HaOHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:07:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1HaOHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:07:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Subject: Re: [patch v2 19/35] Hexagon: Add ptrace support
Date: Wed, 31 Aug 2011 16:07:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
References: <20110830190729.923334292@codeaurora.org> <20110830190801.540467107@codeaurora.org>
In-Reply-To: <20110830190801.540467107@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108311607.41445.arnd@arndb.de>
X-Provags-ID: V02:K0:gO0JhYEMBI7LOu58fY2Jo6hIkkndE4K4fZLZ4mSe8mv
 dNuFsWUot5I9fiOsu4M6LGEqkgxhWzw/JLn11GxDfeSVXEcoSr
 unrWWlm8Igcgb2q/mcKtiOSCK5UHsK8tt1+h9qpqGbPwhiLRlB
 /Meog+JHSExsuPnQI58mx5t1DxmDbOViiQeZwjL4lSzgRG4SXL
 wQD7yJcfTd14tom4xnkcL6Pbk88+QRjnmiureZ9IYqGSjfT5wm
 GO1kvd1ny44zLD1cJaLL19SruN8EliITTnvdIU/sh6NFn1TMuE
 D7xxDkZzoslWcfZLs3MVq+qn0Um6k5U+hVA5K4yDYE4QT4OKMN
 lWbhr1Fs5Cn65RowJ59I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 August 2011, Richard Kuo wrote:
> +
> +       switch (request) {
> +       case PTRACE_POKETEXT:   /* write the word at location addr. */
> +       case PTRACE_POKEDATA:
> +               return generic_ptrace_pokedata(child, addr, data);
> +       case PTRACE_POKEUSR:    /* write register specified by addr. */
> +               return ptrace_pokeusr(child, addr, data);
> +       case PTRACE_GETREGS:
> +               return copy_regset_to_user(child, &hexagon_user_view,
> +                                          REGSET_GPR, 0,
> +                                          sizeof(struct user_regs_struct),
> +                                          udata);
> +       case PTRACE_SETREGS:
> +               return copy_regset_from_user(child, &hexagon_user_view,
> +                                            REGSET_GPR, 0,
> +                                            sizeof(struct user_regs_struct),
> +                                            udata);

I don't remember if I commented on this or if it was for the c6x architecture
submission. Anyway, I think you should let all of this be handled through
the generic ptrace support like openrisc does.

	Arnd
