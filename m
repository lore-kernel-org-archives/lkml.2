Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab2AKSTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 13:19:55 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43386 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2AKSTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 13:19:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120111175952.GI466@moon>
References: <20120111161939.GI8752@moon> <CAHGf_=r1vrZbCTYNAp7e+Hbbxh2BnDXXrdsNckSkQVVrXQ=9KQ@mail.gmail.com>
 <20120111175952.GI466@moon>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 13:19:28 -0500
Message-ID: <CAHGf_=oMk2YDnmsomgCc45Ei5yaSdNzRwapm7Fqm9mN7LY0FNw@mail.gmail.com>
Subject: Re: [RFC] on general object IDs again
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kyle Moffett <kyle@moffetthome.net>, Tejun Heo <tj@kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Kosaki,
>
> the idea on user-space is something like
>
>  - collect all pids to dump
>  - collect IDs for every pid
>  - sort the IDs obtained
>  - find the same IDs (which will be kind of find intersections in a sets of IDs) and
>   set up CLONE_ flags on restore procedure as appropriate (for example if
>   GEN_OBJ_ID_VM IDs for two or more tasks are the same we need to use CLONE_VM
>   at restore time, and so on).

Then, you only need to compare. not any other calculation. i.e. only
need id uniqueness.
And any resource are referenced from tasks. so, can you reuse pid for
this? example,
two taska share one mm.

task-a(pid: 100)
              |-----------------mm
task-b(pid: 200)


gen_obj_id(task-b, GEN_OBJ_ID_VM) return 100. (youngest pid of referenced tasks)
