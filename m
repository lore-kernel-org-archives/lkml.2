Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2BCJKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:10:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915Ab2BCJJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:09:57 -0500
Date: Fri, 3 Feb 2012 10:09:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120203090929.GA23996@elte.hu>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203083530.GD1968@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> > > +			get_random_bytes(&cookies[i][j],
> > > +					 sizeof(cookies[i][j]));
> > 
> > ugly line break.
> > 
> 
> Why? Looks pretty good to me. But sure I'll change it.

It's ugly because it serves no purpose other than pacifying 
checkpatch and makes the code *uglier*.

It's a disease. When checkpatch tells you "this line is too 
long" then consider it a code cleanliness warning!

		And code
	readability and cleanliness
		is not improved
	by random line-
		breaks, right?

'breaking the line' is the *wrong fix* in roughly 90% of the 
cases.

So instead of dumbly breaking the line you need to think about 
*WHY* the line got too long, not just mechanically work around 
the checkpatch warning!

Too long lines can have many reasons, it's usually one of 
several reasons:

     - too much nesting due to too large function.
       solution: break up the function
 or: - too verbose statements with not enough abbreviation
       solution: find a more compact way to write it

or if the code looks compact enough and is not over-nested then 
*leave the line alone*. By breaking it you have not improved - 
you have made it worse.

Thanks,

	Ingo
