Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab0GNBrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:47:47 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51925 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0GNBrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:47:45 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@openvz.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH] pidns: Fix wait for zombies to be reaped in zap_pid_ns_processes
References: <20100625212758.GA30474@redhat.com>
	<20100625220713.GA31123@us.ibm.com>
	<m1r5jd5l0v.fsf_-_@fess.ebiederm.org>
	<m1mxu15kv4.fsf_-_@fess.ebiederm.org>
	<20100709121425.GB18586@hawkmoon.kerlabs.com>
	<m1lj9k4xfx.fsf@fess.ebiederm.org>
	<20100709141324.GC18586@hawkmoon.kerlabs.com>
	<m1aaq04ph2.fsf_-_@fess.ebiederm.org>
	<20100711141406.GD18586@hawkmoon.kerlabs.com>
	<m1tyo4shas.fsf_-_@fess.ebiederm.org>
	<20100713214234.GA21042@hawkmoon.kerlabs.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 13 Jul 2010 18:47:38 -0700
In-Reply-To: <20100713214234.GA21042@hawkmoon.kerlabs.com> (Louis Rilling's message of "Tue\, 13 Jul 2010 23\:42\:35 +0200")
Message-ID: <m1oceakf5x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling <Louis.Rilling@kerlabs.com> writes:

> This patch looks like it is working (only a small RCU issue shown below). I
> couldn't try it yet though.

It certainly worked in my testing. 

> I must admit that I am using a similar back-off solution in Kerrighed (not to
> solve the issue of proc_flush_task(), but for one of the reasons that you stated
> above: we want to be sure that all tasks of the namespace have been reaped), but
> I considered it too ugly to propose it for Linux ;)

Well sometimes you have to go with what works.

Thanks for spotting those issue with my patch.  I guess it needs one more
pass before I can call it done.

> That said, this is probably the least intrusive solution we have seen yet.

Thanks for the review.  The bug where processes can escape a pid
namespace is really the reason I did it this way.  I also have the
patches needed to cleanly fix the pid namespace ref counting.
(Hopefully I can get them posted soon).  So if there was just the
ref counting bug I would drop this patch.

Eric
