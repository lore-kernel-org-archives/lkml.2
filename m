Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0J3HAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 03:00:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55542 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0J3HAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 03:00:01 -0400
Date: Sat, 30 Oct 2010 00:07:33 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Containers <containers@lists.osdl.org>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] pidns: Fix wait for zombies to be reaped in
	zap_pid_ns_processes
Message-ID: <20101030070733.GA21401@us.ibm.com>
References: <m1r5jd5l0v.fsf_-_@fess.ebiederm.org> <m1mxu15kv4.fsf_-_@fess.ebiederm.org> <20100709121425.GB18586@hawkmoon.kerlabs.com> <m1lj9k4xfx.fsf@fess.ebiederm.org> <20100709141324.GC18586@hawkmoon.kerlabs.com> <m1aaq04ph2.fsf_-_@fess.ebiederm.org> <20100711141406.GD18586@hawkmoon.kerlabs.com> <m1tyo4shas.fsf_-_@fess.ebiederm.org> <20100713214234.GA21042@hawkmoon.kerlabs.com> <m1oceakf5x.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1oceakf5x.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| Louis Rilling <Louis.Rilling@kerlabs.com> writes:
| 
| > This patch looks like it is working (only a small RCU issue shown below). I
| > couldn't try it yet though.
| 
| It certainly worked in my testing. 
| 
| > I must admit that I am using a similar back-off solution in Kerrighed (not to
| > solve the issue of proc_flush_task(), but for one of the reasons that you stated
| > above: we want to be sure that all tasks of the namespace have been reaped), but
| > I considered it too ugly to propose it for Linux ;)
| 
| Well sometimes you have to go with what works.
| 
| Thanks for spotting those issue with my patch.  I guess it needs one more
| pass before I can call it done.

Eric,

Do you plan to resend this patch ? 

FYI, we ran into the problem that Louis Rilling reported when testing with
the checkpoint/restart code and this patch fixes the problem (after a minor
tweak to the C/R code).

Thanks,

Sukadev
