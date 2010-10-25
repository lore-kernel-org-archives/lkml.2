Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0JYO4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 10:56:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0JYOz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 10:55:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com>
References: <4CC5B1A1020000780001EF7C@vpn.id2.novell.com> <20101025140218.5092.74117.stgit@warthog.procyon.org.uk>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, torvalds@osdl.org,
        "Ingo Molnar" <mingo@elte.hu>,
        "Alexander van Heukelum" <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Partially revert patch that encloses asm-offset.h numbers in brackets
Date: Mon, 25 Oct 2010 15:54:25 +0100
Message-ID: <28707.1288018465@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich <JBeulich@novell.com> wrote:

> Isn't this a gas bug then? Anywhere you use a plain number you
> should also be permitted to use an expression.

Whoever defined the gas assembly syntax for binutils specified that (N) as an
operand defines an absolute address and N defines an immediate value.

However, prefixing an expression with a unary plus works for me, so adding
this into my patch:

-	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 \2 /* \3 */:; \
+	s:^->\([^ ]*\) [\$$#]*\([-0-9]*\) \(.*\):#define \1 +(\2) /* \3 */:; \

Does that work for you?

David
