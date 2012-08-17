Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2HQUwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 16:52:51 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:51039 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2HQUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 16:52:42 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2012 16:52:42 EDT
Message-ID: <502EAB4D.90807@halfdog.net>
Date: Fri, 17 Aug 2012 20:36:29 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14a1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Software interrupt 0x8 guest crash from userspace: virtualbox emulation
 or guest kernel bug?
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have observed a strange guest kernel crash in virtualbox and are
currently trying to understand it. Since I have no real 32-bit Intel
platform any more, I cannot verify that this crash would happen on
native 32bit also, so perhaps someone could check that. I have also
collected information about the crash [1], but currently fail to
understand why this is happening.

In short: Calling "int 0x8" in i386 guest on amd64 host crashes the
guest. It seems, that "int 0x8" is handled by task gate, that fails to
initialize "gs" correctly. The crash can be reproduced using [2], the
same program does not crash the host. Due to lack of test platforms it
is not clear, if that only affects virtual box guests.

Questions:
* Does this idt entry seem sane or could it be really broken? Code says
./arch/x86/kernel/traps.c:      set_intr_gate_ist(8, &double_fault,
DOUBLEFAULT_STACK);
which seems consistent with observed idt setup. I'm not sure about
privilege levels, is it possible to invoke this interrupt also on
native systems and cause same behavior?
* If broken, what is idt on native i386 system (not guest) on real
32-bit CPU? Could someone with such system send me: grep "idt_table"
in System.map, "gdb --core /proc/kcore" and "x/64x [address of
idt_table]" (see also [1])?
* If broken, why? Same outcome on native i386 platform?
* If not broken on native: why this interaction with virtualbox?

hd

[1]
http://www.halfdog.net/Security/2012/VirtualBoxSoftwareInterrupt0x8GuestCrash/
[2]
http://www.halfdog.net/Security/2012/VirtualBoxSoftwareInterrupt0x8GuestCrash/RtcInt.c

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlAuqz8ACgkQxFmThv7tq+6CzwCginL/PMRVIKxRV4YRXtRIRF+O
tO4An2KcZs5caaoTFu+UGJQLtFOrmKpS
=9P33
-----END PGP SIGNATURE-----
