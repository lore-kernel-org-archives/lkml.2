Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab2DKAI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 20:08:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52141 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab2DKAI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 20:08:56 -0400
Message-ID: <4F84CB21.80907@zytor.com>
Date: Tue, 10 Apr 2012 17:06:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
References: <20120215143606.GA14037@redhat.com> <20120215160652.GA17680@redhat.com> <20120215162752.GF4533@moon>            <20120409151027.7f3e0fa5.akpm@linux-foundation.org> <7939.1334102329@turing-police.cc.vt.edu>
In-Reply-To: <7939.1334102329@turing-police.cc.vt.edu>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 04:58 PM, Valdis.Kletnieks@vt.edu wrote:
> 
> I'm not able to convince myself that "less than" and "greater than"
> mean anything - do we have a good proof that for all v1 and v2, the
> obfuscated pointers have the same ordering as the original
> pointers?
> 

No, of course they don't.

That's the point.

The whole point is that kcmp() exports an ordered set, but the
ordering is explicitly and intentionally different than the actual
ordering in memory.  It is still valid for sorting, in particular.

> Hmm... consider the simplified example  v1 = 5 and v2= 16., and
> cookies[0] is also 16. Then obfus(v1) == 21, and obfus(v2) == 0,
> and the ordering is different.  So I'm thinking 0 and 3 are the
> only sane return values?
> 
> Or do I need more caffeine?

You need more caffeine.  You're thinking about the problem wrong.

	-hpa
