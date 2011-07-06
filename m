Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1GFSIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:08:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235Ab1GFSI3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110706173631.GA5431@albatros>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jul 2011 11:01:47 -0700
Message-ID: <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
Subject: Re: RLIMIT_NPROC check in set_user()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, Neil Brown <neilb@suse.de>,
        kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 10:36 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> On Sun, Jun 12, 2011 at 17:09 +0400, Vasiliy Kulikov wrote:
>> I'd be happy to hear opinions about improving the fixes above or
>> alternative fixes.
>
> No comments?  Even "Sigh, what a nasty problem.  But we cannot really
> fix it without significantly breaking the stuff.  Go and drink something." ?

Thanks for reminding me.

My reaction is: "let's just remote the crazy check from set_user()
entirely". If somebody has credentials to change users, they damn well
have credentials to override the RLIMIT_NPROC too, and as you say,
failure is likely a bigger security threat than success.

The whole point of RLIMIT_NPROC is to avoid fork-bombs. If we go over
the limit for some other reason that is controlled by the super-user,
who cares?

So let's keep it in kernel/fork.c where we actually create a *new*
process (and where everybody knows exactly what the limit means, and
people who don't check for error cases are just broken). And remove it
from everywhere else.

Hmm?

                     Linus
