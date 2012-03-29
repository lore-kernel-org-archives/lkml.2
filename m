Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab2C2ShO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:37:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63061 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab2C2ShL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:37:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120329182632.GA6891@redhat.com>
References: <20120329155542.GA31285@redhat.com> <CA+55aFxOcMt_mcr+ZYwc-SpKbROnh4Gn7jqrFY_SZcBy1Ev7Qw@mail.gmail.com>
 <20120329182632.GA6891@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 11:36:49 -0700
X-Google-Sender-Auth: Co9dB5XiKuS7zms7UD2PCY3oL2E
Message-ID: <CA+55aFx-nzGm1ZZD5bNxmPF2orkXc1_4nCE0jdtznz+AqhBx3A@mail.gmail.com>
Subject: Re: lockups shortly after booting in current git.
To: Dave Jones <davej@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 11:26 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, Mar 29, 2012 at 09:03:31AM -0700, Linus Torvalds wrote:
>  > Can you do sysrq-w (or whatever it is that does only the D-state
>  > processes)? That might give the more relevant process information without
>  > everything else making it unreadable...
>
> http://codemonkey.org.uk/junk/process-trace2.txt

Ok, this doesn't look all that different, but now it's not truncated
any more because the random "waits for children or poll" cases are
gone.

It's still basically all blocked on the ext4 journal. All writes as
far as I can see.

That said, there's that odd kworker/1:2 there that seems to be
constantly running. Can you get the EIP for that one (several times)
by doing sysrq-p (or maybe sysrq-l is better - that should give the
stack trace too).

                        Linus
