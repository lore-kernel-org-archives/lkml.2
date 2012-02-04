Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab2BDDKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 22:10:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54177 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BDDKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 22:10:00 -0500
MIME-Version: 1.0
In-Reply-To: <1328319226.21255.28.camel@joe2Laptop>
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
 <1328311239.21255.24.camel@joe2Laptop> <CA+55aFxHih0+P=aNromTy+f_Rt+++QWgaEdvqLsXg_q_hu_q2A@mail.gmail.com>
 <1328319226.21255.28.camel@joe2Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Feb 2012 19:09:37 -0800
X-Google-Sender-Auth: RdPrmbdN2Zhj-epc8wqRq8LrQm0
Message-ID: <CA+55aFxqWFRNgR_C9sRCOQ6Vh9PF8anomZsfGD9HP49JgAb57A@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 5:33 PM, Joe Perches <joe@perches.com> wrote:
>
> You liked the same premise, but a worse
> implementation, a couple years ago.
> https://lkml.org/lkml/2009/12/18/289

I have grown to dislike debatable parts of checkpatch over the years,
which probably colors my reaction to things like this.

I'd prefer for checkpatch to check things that are fairly black-and-white.

>> Why? Because mindless checks like this would just lead to people
>> making things worse and intermixing spaces there instead.
>
> Can't happen.
> They'll get a different warning about mixing tabs
> and spaces or starting a line with spaces only.

Ok,. fair enough. That makes it more likely to work.

That said, I did a grep for six tabs, and we do seem to have quite a
bit of code like that. 67 _thousand_ lines just in C files, if I did
my grep right.

And many of them seem reasonable. Quite a lot of them seem to be to
just line things up with the previous line. Although some really are
due to excessively deep indentation. But it doesn't seem exactly
black-and-white to me.

                       Linus
