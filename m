Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2BDDgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 22:36:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37578 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2BDDgD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 22:36:03 -0500
MIME-Version: 1.0
In-Reply-To: <1328325697.21255.41.camel@joe2Laptop>
References: <20120130140905.441199885@openvz.org> <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu> <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu> <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
 <1328311239.21255.24.camel@joe2Laptop> <CA+55aFxHih0+P=aNromTy+f_Rt+++QWgaEdvqLsXg_q_hu_q2A@mail.gmail.com>
 <1328319226.21255.28.camel@joe2Laptop> <CA+55aFxqWFRNgR_C9sRCOQ6Vh9PF8anomZsfGD9HP49JgAb57A@mail.gmail.com>
 <1328325697.21255.41.camel@joe2Laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 Feb 2012 19:35:40 -0800
X-Google-Sender-Auth: gFqxRAddm4VRPPP_Tpy1Uwbv1ts
Message-ID: <CA+55aFxGVS8+F+7nLJ90tuwj5_3wqJ3=bdRAx9XUQ95vOb2VyQ@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 7:21 PM, Joe Perches <joe@perches.com> wrote:
>
> I think that's a bad test.
> It finds a _lot_ of line continuations.
>
> The right test is _only_ for 6 or more tabs
> followed by (if|for|while|do|else|switch)

Fair enough.

And I have to admit that doing your grep with an additional -4 to see
some context does make a fairly strong argument for your patch.

The code in drivers/isdn/hisax/hfc_usb.c that triggers is absolutely
disgusting, and does crazy things due to the long lines.

As is some other code that grep shows.

In fact, I think that grep convinced me that you are right about this
particular pattern. Brr. Now I need to go dig my eyes out with a
spoon.

                    Linus

>
> $ grep -rP --include=*.[ch] "^\t{6,}(if|for|while|do|else|switch)" * | \
>  wc -l
> 1509
>
>
