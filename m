Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab2C2VAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:00:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52897 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933849Ab2C2U7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:59:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120329203926.GA13970@thunk.org>
References: <20120329155542.GA31285@redhat.com> <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com> <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
 <20120329195354.GA11790@redhat.com> <CA+55aFxyutCDZhVa8HCu=hpn0454sfoM27Jwh2heCN0cqg5pjA@mail.gmail.com>
 <20120329202619.GA14001@redhat.com> <20120329203926.GA13970@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 13:59:33 -0700
X-Google-Sender-Auth: njLw1CaEzz12Y-Sx6aCAAlEb7CM
Message-ID: <CA+55aFwJkN2BmZJmWfB6FU0TuVKfmh4um8pMKYVUk3aG7JkNwQ@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: "Ted Ts'o" <tytso@mit.edu>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 1:39 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
> I'd suggest restricting the bisect to fs/ first, and if that comes up
> with something non-sensical, you can always use the good/bad data
> points for a whole tree bisect.
>
> One commit that you might want to try testing is b43d17f31^, and see
> whether that works.  One potential commit that might be suspicious is
> b43d17f31 given the stack trace shows one process apparently waiting
> on PageWriteback.

Ahh, that does sound interesting and relevant.

Yeah, maybe the directed approach is worth it. In fact, considering
the above commie, maybe it might be worth it to be *very* directed,
and just test that one thing first, and maybe even skip the bisection
entirely and just test a revert if it looks promising.

                       Linus
