Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0CZN57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 09:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab0CZN56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 09:57:58 -0400
Date: Fri, 26 Mar 2010 14:56:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Grzegorz Nosek <root@localdomain.pl>, Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326135622.GC15790@redhat.com>
References: <20100321195044.GA23757@megiteam.pl> <20100323212834.GH20796@count0.beaverton.ibm.com> <20100325213356.GB20541@megiteam.pl> <20100326111131.GA8604@redhat.com> <20100326115357.GA3345@count0.beaverton.ibm.com> <20100326124522.GD17113@megiteam.pl> <20100326125459.GD3345@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326125459.GD3345@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Matt Helsley wrote:
>
> That said there are
> plenty of #ifdefs in strace and patching it to use GETEVENTMSG is quite
> a small patch.

Not really, unless I missed something. See my another email, strace
doesn't even use the notification from do_fork(), not only it doesn't
read ->ptrace_message.

> However, as I said, that still doesn't "fix" strace so that it can
> be used to trace tasks in child pid namespaces.

Yes. Looks like, the necessary change in kernel is simple (and btw,
it is well known fact the reported pid is not ns-friendly). What
should be really fixed is strace/etc.

> Especially when the
> traced tasks are more than one namepace deeper. :(

Hmm... I guess, you mean setns() idea? Otherwise, I _think_ that the
deeper namepaces are fine wrt pid_nr.

> I don't think the kernel provides special out-of-band methods for fetching
> pids related to traced tasks except during fork and clone. Not wait*().

Could you clarify? I think wait*() is already namespace-friendly?

Oleg.

