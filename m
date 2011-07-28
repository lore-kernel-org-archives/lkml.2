Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1G1UAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:00:35 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:46377 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1G1UAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:00:33 -0400
X-Greylist: delayed 1939 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 16:00:33 EDT
Message-ID: <4E31B80A.4050701@halfdog.net>
Date: Thu, 28 Jul 2011 19:27:06 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0a1) Gecko/20110706 Firefox/8.0a1 SeaMonkey/2.5a1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [57/99] exec: delay address limit change until point
 of no return
References: <4E311559.60402@halfdog.net> <20110728173124.GI8006@one.firstfloor.org>
In-Reply-To: <20110728173124.GI8006@one.firstfloor.org>
X-Enigmail-Version: 1.3a1pre
X-Enigmail-Draft-Status: 513
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This should be continuation of http://lkml.org/lkml/2011/7/27/488

Andi Kleen wrote:
> On Thu, Jul 28, 2011 at 07:52:57AM +0000, halfdog wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> Hello Mr. Kleen,
>> 
>> I saw your posting on lkml. Currently, I have no deep enough 
>> understanding of kernel memory management, so do you think, that 
>> delaying could make a otherwise irrelevant timerace in exec arg
>> handling somehow problematic?
> 
> I guess it would be better to fix it. Can you post your analysis to
> linux-kernel@vger.kernel.org ?  Feel free to cc me.

Please see
https://bugzilla.kernel.org/show_bug.cgi?id=39222
for analysis (Timerace in sys_execve when copying argv/env data from
userspace)

Seems to be historic, but not critical timerace (POC available, but no
crash, mem-leaks, ..).

- From my opinion, it should be possible to make the argv ptr go over the
0xc0000000 kernel/user split on x86 architectures, but I do not know if
the patch in discussion would worsen the situation. Until now, I failed
to trouble the kernel using this.

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFOMbgIxFmThv7tq+4RAqckAJoCeYCAdrxzWk4UXWtklubfvGR1RwCeMG+J
Yj6zC0mawHkthGGA3kEPEa4=
=SLlm
-----END PGP SIGNATURE-----
