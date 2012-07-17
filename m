Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab2GQPMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 11:12:01 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:31750 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754036Ab2GQPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 11:12:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cb4uI6wVM1lhverPnUF2RyZcj.Wg04ahuF4RQtKdZaEG3Jf
 9ax.i3r8h2fZOAKuYrwgfmZ6vPMqaBwTJymhrk4fIVNEXOL.GulGSFXRCh2r
 _daLJ1Y3lIvxxyLZIHV8AW6doRu5ABtUIT5D.c8WPkNcEXyjeDA_Uyk98vsK
 yTlZKHawKPdsXlfGZ_KRLnS4ZXYzD9jpMIuSj.xKUKLRLTT0KN6L5fS0StOn
 wZGdLxxqTS4Rd2cpWhKnkWOaFxGyo6R6Zf.XCZf7a8gWUkRy63l2dTSce6eg
 PUgpkALglS80Hc2CRHUYUkAahHlwaYHKVZ1J6sc6bSNKDWqHjan0InvRHlvw
 mU3wFcUgEz7m6Q_FcyQdv75Eht35XdIir6rgoSalw0o6u.EPgq8BuA3fYcfF
 NvuFcwxiLKJgeHbNXNIAqqVanDlcgswSspReQ
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jul 2012 10:11:56 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: David Rientjes <rientjes@google.com>, Shuah Khan <shuah.khan@hp.com>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <CAOJsxLECr7yj9cMs4oUJQjkjZe9x-6mvk76ArGsQzRWBi8_wVw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207171005550.15061@router.home>
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2> <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1207160915470.28952@router.home> <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com> <alpine.DEB.2.00.1207161506390.32319@router.home> <alpine.DEB.2.00.1207161642420.18232@chino.kir.corp.google.com> <alpine.DEB.2.00.1207170929290.13599@router.home>
 <CAOJsxLECr7yj9cMs4oUJQjkjZe9x-6mvk76ArGsQzRWBi8_wVw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012, Pekka Enberg wrote:

> Well, even SLUB checks for !name in mainline so that's definitely
> worth including unconditionally. Furthermore, the size related checks
> certainly make sense and I don't see any harm in having them as well.

There is a WARN_ON() there and then it returns NULL!!! Crazy. Causes a
NULL pointer dereference later in the caller?

> As for "in_interrupt()", I really don't see the point in keeping that
> around. We could push it down to mm/slab.c in "__kmem_cache_create()"
> if we wanted to.

Ok we could do that but I guess we are in the discussion of how much
checking should be done for a production kernel.

I think these checks are way out of hand. We cannot afford to
consistently check parameters to all kernel functions in production. We
will only do these checks in a select manner if these values could
result in serious difficult to debug problems. The checks in slab look
like debugging code that someone needed for a specific debugging scenario.

I can understand that we would keep that in for development but not for
production. Maybe I am a bit biased but my prod kernels need to have
minimal memory footprint due to excessive code size causing regressions.



