Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1DNUeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:34:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926Ab1DNUeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110414201045.GB25828@redhat.com>
References: <20110411171957.GA32469@redhat.com> <20110411172137.GE32469@redhat.com>
 <20110412183314.GA16342@mtj.dyndns.org> <20110414201045.GB25828@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Apr 2011 13:33:14 -0700
Message-ID: <BANLkTim7D_+nmjU9ewZWoKftZ+_7YSegVQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] signal: sigprocmask() should do retarget_shared_pending()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 1:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Well, I don't know the common definition... But please note that
> signandsets() does ((x) & ~(y)), so I defined nor as (x | ~y) by analogy.

Yeah, "nand" is really "not and" (ie "~((x)&(y))").

The expression ((x) & ~(y)) should typically be called "andn" (see for
example the x86 instruction set "pandn" and "andnpd" or whatever they
are called for sse instructions).

And "nor" really should be "~(x|y)". You want the "orn" combination
(and the famously hard-to-google "porn" instruction for the vectorized
version)

                Linus
