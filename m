Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab2LYP3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 10:29:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab2LYP3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 10:29:00 -0500
Date: Tue, 25 Dec 2012 16:27:16 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/4] signalfd: add ability to return siginfo in a raw
	format
Message-ID: <20121225152716.GA3198@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-2-git-send-email-avagin@openvz.org> <20121224165306.GA9553@redhat.com> <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com> <20121225143043.GA1813@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121225143043.GA1813@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25, Oleg Nesterov wrote:
>
> And if we add another format we should think
> twice.

And btw this applies to the whole series.

I guess that probably you actually need DUMP, not DEQUEUE. but the
latter is not trivial. However, perhaps we can do this assuming that
all other threads are sleeping and nobody can do dequeue_signal().
Say, we can play with ppos/llseek. If *ppos is not zero,
signalfd_dequeue() could dump the nth entry from list or return 0.

Oleg.

