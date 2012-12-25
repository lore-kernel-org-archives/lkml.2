Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2LYQ6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 11:58:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab2LYQ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 11:58:42 -0500
Date: Tue, 25 Dec 2012 17:58:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Wagin <avagin@gmail.com>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH 1/4] signalfd: add ability to return siginfo in a raw
	format
Message-ID: <20121225165803.GA9066@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org> <1356336807-5517-2-git-send-email-avagin@openvz.org> <20121224165306.GA9553@redhat.com> <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com> <20121225143043.GA1813@redhat.com> <20121225152716.GA3198@redhat.com> <50D9C8E9.6020602@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D9C8E9.6020602@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25, Pavel Emelyanov wrote:
>
> On 12/25/2012 07:27 PM, Oleg Nesterov wrote:
> >
> > I guess that probably you actually need DUMP, not DEQUEUE. but the
> > latter is not trivial. However, perhaps we can do this assuming that
> > all other threads are sleeping and nobody can do dequeue_signal().
> > Say, we can play with ppos/llseek. If *ppos is not zero,
> > signalfd_dequeue() could dump the nth entry from list or return 0.
>
> This would be perfect, but isn't it better to preserve the pos
> semantics -- we do know size of entry we're about to copy, we can
> treat pos as offset in bytes, not in elements.

nr-of-records looks better (more flexible) than nr-of-bytes to me. And
perhaps we can also encode private-or-shared into ppos. But I will not
argue in any case.

Oleg.

