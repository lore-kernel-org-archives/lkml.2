Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab1KSFaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 00:30:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35171 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab1KSFaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 00:30:14 -0500
Date: Sat, 19 Nov 2011 09:30:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-ID: <20111119053007.GE21041@moon>
References: <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon>
 <20111118123728.554b45e7.akpm@linux-foundation.org>
 <20111118210322.GD21041@moon>
 <CAOJsxLFLxKGTzxjotAYv-d7Qzn5cqc1AGhXX0FSiK1i3to19Tg@mail.gmail.com>
 <CAGZ=bqJBWboHrh_zc4mWNK5DuY3vy1+QhrMosXK4nusfqDbRSQ@mail.gmail.com>
 <20111118234635.GB29378@google.com>
 <CAGZ=bqJSDjfkx3E_WDh77j7cmNS0AcFoKe6oBHLbiEQC+qGn-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGZ=bqJSDjfkx3E_WDh77j7cmNS0AcFoKe6oBHLbiEQC+qGn-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 08:09:12PM -0500, Kyle Moffett wrote:
...
> >
> > The new version is using different poison for different types of
> > objects.
> 
> Even still, if you use a one-time pad (IE: XOR with a random data
> value) to obscure more than exactly 1 object total, ever, all of its
> security properties are null and void.
>

True. It's not one-time pads there.

> 
> >> If you actually want to be able to compare uniqueness without exposing
> >> anything vulnerable to various kinds of guessing, you should generate
> >> a random 64-bit value for each class of object and then use a proper
> >> cryptographic hash function on it:
> >>   crypto_hash(concat(object_ptr, random_value))
> >>
> >> Even given the best possible practical attacks against SHA1 or MD5
> >> today both still provides more than enough security to prevent someone
> >> from guessing "object_ptr" in less than an absurd amount of time.
> >
> > So, per-type poison + crypto hash, it is then.
> 
> Yes.  I haven't thought through whether or not you would ever care
> about a system giving out the same number for two different kinds of
> object.  The only possible vulnerability I can think of would be if
> the kernel had a use-after-free bug... You could allocate and free a
> bunch of the vulnerable objects and use this data-structure-ID system
> to find an allocated data-structure of a different type which matches
> up with one of the used-after-freed ones.  Then in theory you could
> compromise something, I suppose.
> 
> Sort of an off-the-wall scenario, I will admit.
> 
> The per-type random value is certainly a safe bet and should have zero
> actual impact on performance.  Good luck!
> 

Thanks for all comments Kyle! Of course address allocation specifics with
simple xor wont give us enough obscurity here. If we stick with root-only
approach then we don't need this scheme at all but could expose plain
addresses. I'm waiting for Pavel's comment on such approach.

	Cyrill
