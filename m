Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965783Ab0COTZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:25:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50294
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965760Ab0COTZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:25:44 -0400
Date: Mon, 15 Mar 2010 12:26:05 -0700 (PDT)
Message-Id: <20100315.122605.124976085.davem@davemloft.net>
To: acme@infradead.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       efault@gmx.de, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100315192125.GL6965@ghostprotocols.net>
References: <1268664418-28328-2-git-send-email-acme@infradead.org>
	<20100315.115526.52182155.davem@davemloft.net>
	<20100315192125.GL6965@ghostprotocols.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Mon, 15 Mar 2010 16:21:26 -0300

> Em Mon, Mar 15, 2010 at 11:55:26AM -0700, David Miller escreveu:
>> Arnaldo, if perf top can use the kallsyms to do it's normal task, why
>> can't it use that for symbol annotations too?  Isn't there enough
>> information available?
> 
> Annotation is done by objdump -dS, that requires an executable file to
> do ASM annotation, and one with DWARF info for source code annotation.
> What we have with /proc/kallsyms is just the symtab.

Ok, I really think we should link with libopcodes or similar so we can
handle the simple assembler annotation case without requiring the
kernel image being available.

That's what I was trying to achieve when I sent you the report
:-)
