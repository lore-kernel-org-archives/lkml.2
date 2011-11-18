Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1KRXqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:46:43 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62167 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1KRXqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:46:42 -0500
Date: Fri, 18 Nov 2011 15:46:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Pekka Enberg <penberg@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
Message-ID: <20111118234635.GB29378@google.com>
References: <4EC4DA15.7090106@parallels.com>
 <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com>
 <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon>
 <20111118123728.554b45e7.akpm@linux-foundation.org>
 <20111118210322.GD21041@moon>
 <CAOJsxLFLxKGTzxjotAYv-d7Qzn5cqc1AGhXX0FSiK1i3to19Tg@mail.gmail.com>
 <CAGZ=bqJBWboHrh_zc4mWNK5DuY3vy1+QhrMosXK4nusfqDbRSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGZ=bqJBWboHrh_zc4mWNK5DuY3vy1+QhrMosXK4nusfqDbRSQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 18, 2011 at 05:10:37PM -0500, Kyle Moffett wrote:
> The #1 rule of one-time pads is never use it for more than one thing,
> and you use it here for every object in the system.

The new version is using different poison for different types of
objects.

> If you actually want to be able to compare uniqueness without exposing
> anything vulnerable to various kinds of guessing, you should generate
> a random 64-bit value for each class of object and then use a proper
> cryptographic hash function on it:
>   crypto_hash(concat(object_ptr, random_value))
> 
> Even given the best possible practical attacks against SHA1 or MD5
> today both still provides more than enough security to prevent someone
> from guessing "object_ptr" in less than an absurd amount of time.

So, per-type poison + crypto hash, it is then.

Thank you very much.

-- 
tejun
