Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab0JNTRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:17:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009Ab0JNTRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:17:04 -0400
Date: Thu, 14 Oct 2010 12:16:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: mmotm 2010-10-13-17-13 uploaded
Message-Id: <20101014121627.2405e99a.akpm@linux-foundation.org>
In-Reply-To: <AANLkTin1RjhDZp6w-jumRnZ1-Hx3zio7SrZtZqummok2@mail.gmail.com>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
	<AANLkTin1RjhDZp6w-jumRnZ1-Hx3zio7SrZtZqummok2@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 12:26:45 +0200
Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:

> 2010/10/14  <akpm@linux-foundation.org>:
> > The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> 
> linux-next.patch breaks things
> 
>   GEN     /home/test/linux-2.6-obj/Makefile
>   HOSTCC  scripts/kconfig/zconf.tab.o
> In file included from scripts/kconfig/zconf.tab.c:2462:0:
> scripts/kconfig/lex.zconf.c:2425:7: error: conflicting types for 'zconf_curname'
> /home/test/linux-2.6-mm/scripts/kconfig/lkc.h:79:13: note: previous
> declaration of 'zconf_curname' was here
> scripts/kconfig/lex.zconf.c: In function 'zconf_curname':
> scripts/kconfig/lex.zconf.c:2427:2: warning: return discards
> qualifiers from pointer target type
> make[3]: *** [scripts/kconfig/zconf.tab.o] Error 1
> make[2]: *** [silentoldconfig] Error 2
> make[1]: *** No rule to make target `include/config/auto.conf', needed
> by `include/config/kernel.release'.  Stop.
> make: *** [sub-make] Error 2
> 

Something went wrong with the zconf_curname() constification.

lex scripts never seem to get along well with the build dependency
systems - did you try a `make mrproper' and a rebuild?

