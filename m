Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826Ab1FATus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:50:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759796Ab1FATum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:50:42 -0400
Date: Wed, 1 Jun 2011 21:01:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 11/17] ptrace: implement PTRACE_SEIZE
Message-ID: <20110601190117.GB6504@redhat.com>
References: <1306710760-16440-1-git-send-email-tj@kernel.org> <1306710760-16440-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306710760-16440-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Tejun Heo wrote:
>
> implements a new ptrace request PTRACE_SEIZE which attaches and traps
> tracee

it doesn't trap the tracee ;)

> * PTRACE_SEIZE, unlike ATTACH, doesn't force tracee to trap.  After
>   attaching tracee continues to run unless a trap condition occurs.

OK.

Just to remind, tracehook_report_clone() shouldn't send SIGSTOP if
the auto-attached tracee is PT_SEIZED.

> * If PTRACE_SEIZE'd, group stop uses PTRACE_EVENT_STOP trap which uses
>   exit_code of (SIGTRAP | PTRACE_EVENT_STOP << 8) instead of the
>   stopping signal number

Hmm. May be it would be better to report stopping_signal | PTRACE_EVENT_STOP
instead... I am not sure yet, but it seems this way we can avoid the
PTRACE_GETSIGINFO changes. I'll try to explain later, when I finsh the
reading.

Oleg.

