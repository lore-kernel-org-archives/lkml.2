Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab2BEQV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 11:21:27 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:35643 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751684Ab2BEQV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 11:21:26 -0500
Message-ID: <1328458885.7008.58.camel@joe2Laptop>
Subject: Re: [PATCH, v2] checkpatch: Warn on code with 6+ tab indentation,
 remove 80col warning
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>,
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
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Date: Sun, 05 Feb 2012 08:21:25 -0800
In-Reply-To: <20120205113821.GA22399@elte.hu>
References: <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop> <20120204130330.GA30198@elte.hu>
	 <1328372536.5766.3.camel@joe2Laptop> <20120204180237.GA7682@elte.hu>
	 <1328381300.5996.2.camel@joe2Laptop>
	 <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
	 <1328383659.7008.7.camel@joe2Laptop> <20120205113821.GA22399@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-05 at 12:38 +0100, Ingo Molnar wrote:
> In practice patch submitters take warnings just as seriously.

In practice, that's not necessarily bad.
I do think there should be some line length limit.
80 might be a bit short.

> If it is emitted by the default checkpatch run, it's acted
> upon. That is the human behavior that is a given.

Look at some of the lines in drivers/staging
that have _really_ long lines that would not
get any warning if this were removed.

$ git ls-files "drivers/staging/*.[ch]" | xargs cat | \
  awk '{print length($0),$0}' | sort -rn | head -50

gotta love the first few...

A few lines in arch/x86 might benefit from
some wrapping too.

