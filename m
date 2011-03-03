Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab1CCTfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:35:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545Ab1CCTfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:35:04 -0500
Date: Thu, 3 Mar 2011 20:26:30 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110303192630.GA32152@redhat.com>
References: <20110301152457.GE26074@htj.dyndns.org> <AANLkTinpVJAsUW83Wu3GNqTzXk=QEamJ=G3N-nrJjJhO@mail.gmail.com> <20110302073236.GC19669@htj.dyndns.org> <AANLkTikyU27CtRgWW4pbdqL9jVYevazTW-t0XBFJ-EeC@mail.gmail.com> <20110302112306.GH3319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302112306.GH3319@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Tejun Heo wrote:
>
> Hey,
>
> On Wed, Mar 02, 2011 at 12:02:37PM +0100, Denys Vlasenko wrote:
> > What do you think about SIGSTOP generated in in children on auto-attach
> > via PTRACE_O_TRACE[V]FORK / PTRACE_O_TRACECLONE options?
>
> Ah, you're right.  I actually haven't been thinking about them.
>
> > IMHO, it would be good if we'd have a way to distinguish them from
> > real SIGSTOP signals.
>
> Yeah, probably.

Perhaps... but at first glance I think we should not change this
at all.

We are not going to change PTRACE_ATTACH, we can't. We are going
to add the new request which avoids tkill(SIGSTOP). The same with
PTRACE_O_TRACECLONE/etc imho. We need the better control on
auto-attach, but this needs another discussion.

Oleg.

