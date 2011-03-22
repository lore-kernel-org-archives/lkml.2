Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1CVP7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:59:37 -0400
Received: from peer.zerties.org ([188.40.33.175]:48483 "EHLO peer.zerties.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab1CVP7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:59:36 -0400
X-Greylist: delayed 2346 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Mar 2011 11:59:35 EDT
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: vamos-dev@i4.informatik.uni-erlangen.de,
        daca-devel@lists.alioth.debian.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia@diku.dk>
Subject: [ANNOUNCE] undertaker 1.1
Organization: Uni Erlangen, Informatik 4, Lehrstuhl =?utf-8?Q?f=C3=BCr?=
 Betriebs- und verteilte Systeme
Date: Tue, 22 Mar 2011 16:20:15 +0100
Message-ID: <864o6v89n4.fsf@peer.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VAMOS team is pleased to announce undertaker 1.1. The undertaker
tool is a result of the VAMOS[1] research project. Please visit our
project site at:

http://vamos.informatik.uni-erlangen.de/trac/undertaker

What is undertaker?
-------------------

The undertaker is a tool for static code analysis for code with C
preprocessor directives that can be used in various modes. The most
prominent one checks every single preprocessor block within the file
whether it can be selected or deselected, which in many cases is a great
asset for code maintenance.

Some preprocessor blocks are only seemingly conditional. In many cases,
it turns out that additional constraints from the project's
configuration model causes such #ifdef blocks to be in fact
unconditionally selected or unselected. We call such block "dead" and
"undead" conditional blocks.

Undertaker provides tools to extract the configuration model from the
Linux configuration tooling Kconfig and to perform this check on whole
source trees.

New in 1.1 is the support for #define and #undef directives in CPP
Code.

 ,----
 | #undef A
 | #ifdef A
 | // Block 1
 | #endif
 `----


Here we identify Block 1 as an dead code-block, because it will never
be compiled into the resulting binary. This analysis can be done
completly without any information about the configuration model.

We have already performed a check on the v2.6.38 tree and provide easy
access to the results via an online interface[2]. There is also a cpio
archive with the report files.

What undertaker is not?
-----------------------

It isn't an automatic patch generator. Because of peculiarities in the
Kconfig semantics, (ignored) coding guidelines and simply engineering
issues, the reports might contain false negatives. Note that our
philosophy is that we prefer false negatives over false positives, i.e.,
we prefer to miss reports than reports that are no issue at all.

What else can i do with undertaker?
-----------------------------------

You can extract boolean formulas (with or without model) for a given
line of sourcecode in a file or for a given symbol. There is also an
integration for emacs for interactive browsing of block and symbol
preconditions.

Additional uses are currently under development.

[1] http://www4.informatik.uni-erlangen.de/Research/VAMOS/
[2] http://www4.informatik.uni-erlangen.de/Research/VAMOS/linux-trees/
