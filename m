Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab1KSBJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 20:09:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47005 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1KSBJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 20:09:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111118234635.GB29378@google.com>
References: <4EC4DA15.7090106@parallels.com> <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com> <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon> <20111118123728.554b45e7.akpm@linux-foundation.org>
 <20111118210322.GD21041@moon> <CAOJsxLFLxKGTzxjotAYv-d7Qzn5cqc1AGhXX0FSiK1i3to19Tg@mail.gmail.com>
 <CAGZ=bqJBWboHrh_zc4mWNK5DuY3vy1+QhrMosXK4nusfqDbRSQ@mail.gmail.com> <20111118234635.GB29378@google.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 18 Nov 2011 20:09:12 -0500
Message-ID: <CAGZ=bqJSDjfkx3E_WDh77j7cmNS0AcFoKe6oBHLbiEQC+qGn-w@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
To: Tejun Heo <tj@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 18:46, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Fri, Nov 18, 2011 at 05:10:37PM -0500, Kyle Moffett wrote:
>> The #1 rule of one-time pads is never use it for more than one thing,
>> and you use it here for every object in the system.
>
> The new version is using different poison for different types of
> objects.

Even still, if you use a one-time pad (IE: XOR with a random data
value) to obscure more than exactly 1 object total, ever, all of its
security properties are null and void.


>> If you actually want to be able to compare uniqueness without exposing
>> anything vulnerable to various kinds of guessing, you should generate
>> a random 64-bit value for each class of object and then use a proper
>> cryptographic hash function on it:
>>   crypto_hash(concat(object_ptr, random_value))
>>
>> Even given the best possible practical attacks against SHA1 or MD5
>> today both still provides more than enough security to prevent someone
>> from guessing "object_ptr" in less than an absurd amount of time.
>
> So, per-type poison + crypto hash, it is then.

Yes.  I haven't thought through whether or not you would ever care
about a system giving out the same number for two different kinds of
object.  The only possible vulnerability I can think of would be if
the kernel had a use-after-free bug... You could allocate and free a
bunch of the vulnerable objects and use this data-structure-ID system
to find an allocated data-structure of a different type which matches
up with one of the used-after-freed ones.  Then in theory you could
compromise something, I suppose.

Sort of an off-the-wall scenario, I will admit.

The per-type random value is certainly a safe bet and should have zero
actual impact on performance.  Good luck!

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
