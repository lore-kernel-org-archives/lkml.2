Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2FWBA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 21:00:27 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4717 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756846Ab2FWBAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 21:00:25 -0400
Message-ID: <1340413223.1773.146.camel@x61.thuisdomein>
Subject: cris: odd include in arch/cris/boot/compressed/misc.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Date: Sat, 23 Jun 2012 03:00:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 23 Jun 2012 01:00:23.0773 (UTC) FILETIME=[91CBE0D0:01CD50DB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael, Jesper,

0) Currently line 123 of arch/cris/boot/compressed/misc.c reads:
    #include "../../../../../lib/inflate.c"

git blame tells me that line has read that way since commit
51533b615e605d86154ec1b4e585c8ca1b0b15b7 ("[...] CRIS update: new
subarchitecture v32"), which predates release v2.6.13.

1) When I try to jump to lib/inflate.c via that line in my $EDITOR, I
see an error and nothing happens. When I check the depth, in
directories, at which misc.c lives, I can't blame my $EDITOR.

2) And indeed, when I edit that line to read:
    #include "../../../../lib/inflate.c"

my $EDITOR does correctly jump to lib/inflate.c. 

3) This can be trivially fixed, and I'm happy to submit that trivial
patch. But I do wonder what the compilers for cris know that my $EDITOR
and x86 compiler doesn't. (I don't have a compiler for cris at hand.)
Because, if I edit the comparable file for x86 to have a similar include
look that way and try to build a kernel I get:

[...]
  CC      arch/x86/boot/compressed/misc.o
arch/x86/boot/compressed/misc.c:131:51: fatal error: ../../../../../lib/decompress_inflate.c: No such file or directory
compilation terminated.
make[2]: *** [arch/x86/boot/compressed/misc.o] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make: *** [bzImage] Error 2

4) What's going on here?


Paul Bolle

