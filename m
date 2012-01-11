Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab2AKTvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:51:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35229 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab2AKTvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:51:17 -0500
MIME-Version: 1.0
In-Reply-To: <4F0DE4B0.4070800@parallels.com>
References: <20120111161939.GI8752@moon> <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
 <20120111175952.GI466@moon> <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
 <4F0DD365.6070200@parallels.com> <20120111183115.GA28196@moon>
 <CAHGf_=oXsrbsXPqBw_CvZQjwdXhzhqkoWX3mRSEgMZHy44ZUKg@mail.gmail.com> <4F0DE4B0.4070800@parallels.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 14:50:55 -0500
Message-ID: <CAHGf_=qs+-YZ-XFx5FyWMhF4Dee3_bCGJXGmKkQ0_ED75KxxOQ@mail.gmail.com>
Subject: Re: [RFC] on general object IDs again
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This might work for mm_structs, although quite a lot apps now do have threads and
> this mm->users check will be negative. But how about open files? Once we entered the
> get-the-youngest-file-owner routine we need to take locks and with 1000 tasks the
> overhead is not 1000 syscalls, but 1000 (syscalls + locks).

Unfortunately, I have no knowledge your program have what assumption
of file modify. When I reviewed mincore patch from you, you said you
assume any file are preserved. And If nobody change the files, why do
we need to care file locks? I have no knowledge a grand picture of
your design at all.
