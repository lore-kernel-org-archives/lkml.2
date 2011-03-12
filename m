Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1CLWLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:11:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35781 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1CLWLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:11:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=AVqaGRFmNyVPi7RSdk4UNApPJD8kxfTk1ilLdiEhMXlWkoTEvACtR5HsGlk5nMjjZf
         tX/2Gq8HTRUOm8hmNVxbNdt9S+a/I1UsIgNuLVCbreFmNDi6dkrhGxRPy2s4v1TgUGRi
         1XX02dXDkXb/lgmKXO6pFdGykawfB2t94P1Ns=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 12 Mar 2011 23:11:11 +0100
Message-ID: <AANLkTimw5O38=7pWASMi508DJMeUdC8+Bp3kW0yKw5CR@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc8
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[QUOTE]
On 2011-03-08 07:40, Linus Torvalds wrote:
> So please keep testing,

Doesn't build:
arch/x86/kernel/entry_64.S: Assembler messages:
arch/x86/kernel/entry_64.S:1531: Error: .size expression does not
evaluate to a constant
make[2]: *** [arch/x86/kernel/entry_64.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make: *** [arch/x86] Error 2

Must be due to recent binutils upgrade, because 2.6.37 doesn't build
anymore either.

Looks like these patches are needed:
http://git.kernel.org/?p=linux/kernel/git/hjl/linux-2.6.37.y.git;a=commitdiff;h=2c5ce9c1b8eb927c131a31d4466e24e00647e9cb
https://patchwork.kernel.org/patch/606241/

Best regards,
--Edwin
[/QUOTE]

There was a long discussion caused by a breakage in linux-next with a
2.21-snapshot release of binutils in Debian/sid:
"Re: linux-next: Tree for March 8 (BROKEN: arch/x86/kernel/entry_32.S?
Debian's binutils/as?)"

The result were two patches [1] and [2] which helped to build a
linux-next kernel with new binutils.
[1] affects also 2.6.38, [2] is for linux-next (upcoming 2.6.39).
Ingo combined both fixes as one [3] and accepted it to
tip:x86/trampoline (see [4]).
This single fix found already its way to linux-next tree (where I am on).

- Sedat -

[1] https://patchwork.kernel.org/patch/619081/
[2] https://patchwork.kernel.org/patch/619611/
[3] https://patchwork.kernel.org/patch/621001/
[4] http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=2ae9d293b14d17f35eff624272cfecac7979a2ee
