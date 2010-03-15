Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676Ab0COSzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:55:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57535
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965653Ab0COSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:55:05 -0400
Date: Mon, 15 Mar 2010 11:55:26 -0700 (PDT)
Message-Id: <20100315.115526.52182155.davem@davemloft.net>
To: acme@infradead.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, acme@redhat.com,
       fweisbec@gmail.com, efault@gmx.de, a.p.zijlstra@chello.nl,
       paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1268664418-28328-2-git-send-email-acme@infradead.org>
References: <1268664418-28328-1-git-send-email-acme@infradead.org>
	<1268664418-28328-2-git-send-email-acme@infradead.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Mon, 15 Mar 2010 11:46:58 -0300

> [root@doppio linux-2.6-tip]# perf top -s n_tty_write > /tmp/bla
> objdump: '[kernel.kallsyms]': No such file
> 
> Now this is what the user gets:
> 
> [root@doppio linux-2.6-tip]# perf top -s n_tty_write
> Can't annotate n_tty_write: No vmlinux file was found in the path:
> [0] vmlinux
> [1] /boot/vmlinux
> [2] /boot/vmlinux-2.6.33-rc5
> [3] /lib/modules/2.6.33-rc5/build/vmlinux
> [4] /usr/lib/debug/lib/modules/2.6.33-rc5/vmlinux
> [root@doppio linux-2.6-tip]#

Arnaldo, if perf top can use the kallsyms to do it's normal task, why
can't it use that for symbol annotations too?  Isn't there enough
information available?

