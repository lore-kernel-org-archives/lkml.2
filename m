Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2CZDCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 23:02:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45124 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2CZDCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 23:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAP=VYLpUzuom-HUS-LYSuQmMZSRvC_Qjgyy9hnKqBowh-95YPQ@mail.gmail.com>
References: <4F57A3EC.7070101@gmail.com>
	<1331660076-32766-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120313131616.f66dbdad.akpm@linux-foundation.org>
	<CAAHN_R3mFzmtCey_0JEHp=EAGh1sb87szpsKD_JkFwwYLCnKug@mail.gmail.com>
	<CAP=VYLpUzuom-HUS-LYSuQmMZSRvC_Qjgyy9hnKqBowh-95YPQ@mail.gmail.com>
Date: Mon, 26 Mar 2012 08:32:35 +0530
Message-ID: <CAAHN_R1_DordNLDjBfWMHyMJ1yhgwiuQfPvtwQzUKpGMkrJ0jw@mail.gmail.com>
Subject: Re: [PATCH] -mm/linux-next: procfs: Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-next <linux-next@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jamie Lokier <jamie@shareable.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Mike Frysinger <vapier@gentoo.org>,
        Oleg Nesterov <oleg@redhat.com>, Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 11:35 PM, Paul Gortmaker
<paul.gortmaker@windriver.com> wrote:
> Now it is:
>
> mm/nommu.o: In function `vm_is_stack':
> nommu.c:(.text+0x2178): multiple definition of `vm_is_stack'
> mm/util.o:util.c:(.text+0x2bc): first defined here
> make[2]: *** [mm/built-in.o] Error 1
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/5941188/

Looks like the problem is because this patch got included in
linux-next 2 days ago:

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=47d1ab583408e5b8e900c5080aec9bbcf210df22

When I had consolidated all of these changes into what Andrew got the
v3 patch from, this patch should have been removed since I moved this
function definition from memory.c and nommu.c into util.c, but it
looks like the patch got merged in once again, causing the build error
above. Dropping this patch should be sufficient to fix the build
problem. This is also the reason why the March 22 build was successful
(with my final changes) and the March 24 build wasn't (with this
additional patch).

-- 
Siddhesh Poyarekar
http://siddhesh.in
