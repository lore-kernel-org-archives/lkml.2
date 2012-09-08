Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2IHMA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 08:00:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44709 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2IHMAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 08:00:24 -0400
X-Auth-Info: lHX5vKwHbwp7a7ojMr8+vWbBWgywIVtVFUvqdMU2Rnc=
From: Andreas Schwab <schwab@linux-m68k.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: [kbuild bug] /bin/sh: -c: line 0: syntax error near unexpected token `;'
References: <20120908014208.GA19345@localhost>
X-Yow: I appoint you ambassador to Fantasy Island!!!
Date: Sat, 08 Sep 2012 14:00:13 +0200
In-Reply-To: <20120908014208.GA19345@localhost> (Fengguang Wu's message of
	"Sat, 8 Sep 2012 09:42:08 +0800")
Message-ID: <m2bohgybaq.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> /usr/bin/make -f /c/kernel-tests/src/next/scripts/Makefile.modbuiltin obj=arch/ia64/kvm

The problem is that Makefile.modbuiltin is executed before
Makefile.build has been executed in arch/ia64/kvm, and the rule in
arch/ia64/kvm/Makefile uses cmd_cc_s_c which is only defined in
Makefile.build.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
