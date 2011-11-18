Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1KRVJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:09:06 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43112 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab1KRVJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:09:04 -0500
MIME-Version: 1.0
In-Reply-To: <20111118210322.GD21041@moon>
References: <4EC4DA15.7090106@parallels.com>
	<20111117124831.688adbeb.akpm@linux-foundation.org>
	<4EC6246A.6020807@parallels.com>
	<20111118110716.c854b4bd.akpm@linux-foundation.org>
	<20111118200342.GC21041@moon>
	<20111118123728.554b45e7.akpm@linux-foundation.org>
	<20111118210322.GD21041@moon>
Date: Fri, 18 Nov 2011 23:09:03 +0200
X-Google-Sender-Auth: a8gBAnpoIjHqYM3dI7VJesX6dfM
Message-ID: <CAOJsxLFLxKGTzxjotAYv-d7Qzn5cqc1AGhXX0FSiK1i3to19Tg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
From: Pekka Enberg <penberg@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:03 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> Of course.  But
>>
>> a) I'm not sure that this scheme actually protects the kernel
>>    addresses - there may be way in which cunning userspace can work out
>>    the random mask.
>
> Well, in case of hw-rng it should not be that easy, still of course
> there is no 100% guarantee that there is absolutely no way to predict
> this mask (espec since it's generated once at lives here forever). But
> whatever makes attacker life harder -- is a good thing. After all we might
> simply take some hash on kernel address here (such as sha256) since it's
> not a time-critical operation and as far as I know collision is not found
> for it yet (??).

XOR cipher is very easy to crack with frequency analysis. I'd also
consider using SHA256 or similar hash for this.
