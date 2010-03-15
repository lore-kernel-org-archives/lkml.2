Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773Ab0COTVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:21:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55897 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750Ab0COTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:21:39 -0400
Date: Mon, 15 Mar 2010 16:21:26 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       efault@gmx.de, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
Message-ID: <20100315192125.GL6965@ghostprotocols.net>
References: <1268664418-28328-1-git-send-email-acme@infradead.org>
 <1268664418-28328-2-git-send-email-acme@infradead.org>
 <20100315.115526.52182155.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100315.115526.52182155.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 15, 2010 at 11:55:26AM -0700, David Miller escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Mon, 15 Mar 2010 11:46:58 -0300
> > [root@doppio linux-2.6-tip]# perf top -s n_tty_write > /tmp/bla
> > objdump: '[kernel.kallsyms]': No such file
> > 
> > Now this is what the user gets:
> > 
> > [root@doppio linux-2.6-tip]# perf top -s n_tty_write
> > Can't annotate n_tty_write: No vmlinux file was found in the path:
> > [0] vmlinux
> > [1] /boot/vmlinux
> > [2] /boot/vmlinux-2.6.33-rc5
> > [3] /lib/modules/2.6.33-rc5/build/vmlinux
> > [4] /usr/lib/debug/lib/modules/2.6.33-rc5/vmlinux
> > [root@doppio linux-2.6-tip]#
> 
> Arnaldo, if perf top can use the kallsyms to do it's normal task, why
> can't it use that for symbol annotations too?  Isn't there enough
> information available?

Annotation is done by objdump -dS, that requires an executable file to
do ASM annotation, and one with DWARF info for source code annotation.
What we have with /proc/kallsyms is just the symtab.

- Arnaldo
