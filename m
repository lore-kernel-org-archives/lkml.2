Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2FZBlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 21:41:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40333 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2FZBlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 21:41:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com> <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com> <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com> <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Jun 2012 18:40:47 -0700
X-Google-Sender-Auth: KtPTwesEyrZ5kOjtDie1a3zZSik
Message-ID: <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 5:56 PM, Kay Sievers <kay@vrfy.org> wrote:
>
> Buffering has nice effects though:
> It makes continuation lines appear as one record in the buffer, not as
> n individual prints with n headers.

As I already mentioned, buffering for *logging* is different from
buffering for *printing*.

I think it might be a great idea to buffer for logging in order to
generate one individual buffer record there.

But it needs to be printed as it is generated.

The printing and the recording really should be thought of as separate
issues. You already record things that aren't printed, so they already
aren't 1:1 relationships.

                     Linus
