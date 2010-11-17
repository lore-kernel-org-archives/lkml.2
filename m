Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0KQF7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:59:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698Ab0KQF7k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:59:40 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
References: <20101116104600.GA24015@suse.de> <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 21:58:44 -0800
Message-ID: <AANLkTikgb96oJCrF-5sBPMUTiNPbCMEGUkuGxAJ=g-Mx@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        w@1wt.eu, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 9:40 PM, Kyle Moffett <kyle@moffetthome.net> wrote:
>
>  (1) For 99%+ of all the computers out there you can

I think that misses the point.

Security is never about absolutes. Anybody who believes in absolute
security is a moron.

True security is about "piling up the inconveniences on the attack".
Several layers. Sure, it's easy to attack a system that is a
monoculture. But immediately when you start saying "you can always
figure out the particular version" and you're talking about tens (or
hundreds) of versions, suddenly you really _are_ more secure. Because
suddenly it's one more pain.

And no, that "one more pain" is not going to be the thing that stops
attacks. But add a number of "one more pains" together, and it gets
increasingly unlikely that you will have a widespread and successful
attack.

So I do think that it's worth closing these "small" holes. Anything
that makes it more work to attack really _is_ improving things.

And being able to just immediately see the addresses is just very
convenient if you have an attack that needs kernel addresses. Much
better that we not make these things visible by default.

And yes, people can look at the vmlinux files. That's outside our
control. And maybe distros will want to close that hole, and maybe
they won't, but at least they don't have the excuse that "well, it's
not even worth it, because the kernel exports that information in
/proc/kallsyms already".

              Linus
