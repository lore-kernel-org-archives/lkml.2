Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2BELjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:39:11 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2BELjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:39:08 -0500
Date: Sun, 5 Feb 2012 12:38:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>
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
Subject: Re: [PATCH, v2] checkpatch: Warn on code with 6+ tab indentation,
 remove 80col warning
Message-ID: <20120205113821.GA22399@elte.hu>
References: <20120203095227.GA13162@elte.hu>
 <20120203100743.GA3334@elte.hu>
 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
 <1328311239.21255.24.camel@joe2Laptop>
 <20120204130330.GA30198@elte.hu>
 <1328372536.5766.3.camel@joe2Laptop>
 <20120204180237.GA7682@elte.hu>
 <1328381300.5996.2.camel@joe2Laptop>
 <CAOJsxLGtkVDZpFn3WY21Z4nqnH159KLyo7sx5rhe73bz712sYw@mail.gmail.com>
 <1328383659.7008.7.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328383659.7008.7.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> +		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) {
> +			if ($length > $max_line_len_strict) {
> +				CHK("LONG_LINE",
> +				     "line over $max_line_len_strict characters\n" . $herecurr);
> +			}
> +			if ($length > $max_line_len_warn) {
> +				WARN("LONG_LINE",
> +				     "line over $max_line_len_warn characters\n" . $herecurr);
> +			}

In practice patch submitters take warnings just as seriously.
If it is emitted by the default checkpatch run, it's acted
upon. That is the human behavior that is a given.

If warnings are often crap and should not be acted upon then 
frankly, don't emit them by default.

I don't care *how* that warning is removed - whether it's 
removed from checkpatch or just hidden from the default view - 
but it needs to be removed or people like Pekka (or me) stop 
using it.

Thanks,

	Ingo
