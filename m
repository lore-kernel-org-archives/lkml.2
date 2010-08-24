Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0HXPPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:15:04 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41691 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752211Ab0HXPPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:15:00 -0400
Date: Tue, 24 Aug 2010 11:14:56 -0400 (EDT)
From: Miloslav Trmac <mitr@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, anton@samba.org,
        Al Viro <viro@zeniv.linux.org.uk>, Michael Neuling <mikey@neuling.org>
Message-ID: <1147049992.1241541282662896620.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1282621410.26616.406.camel@localhost.localdomain>
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Eric Paris" <eparis@redhat.com> wrote:
> Add a new spot in the assembly which will call a function which will
> check if audit_n_rules > 0 and if so will set TIF_SYSCALL_AUDIT and if
> not will clear TIF_SYSCALL_AUDIT?  It might make things slightly worse
> on systems which explictly disable audit and the flag would always be
> clear on every task (like you did with the explicit rule) but I'm
> guessing might be a win on systems with no rules which are wasting time
> on the audit slow path.....
Is "audit_n_rules" a specific enough trigger?  Right now, even if there are no rules configured at all, audit_log_start() while processing a syscall will mark that syscall for auditing, and all collected information about the syscall will be logged at syscall exit.

Would the suggested change break this behavior?
    Mirek
