Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab1EBWmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:42:17 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:13088 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab1EBWmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:42:15 -0400
Message-ID: <4DBF3341.6090908@tilera.com>
Date: Mon, 2 May 2011 18:42:09 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH 1/1] tile: do_hardwall_trap: do not play with task->sighand
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org> <1302031310-1765-3-git-send-email-matt@console-pimps.org> <20110413194231.GA15330@redhat.com> <20110414113456.5182a582@mfleming-mobl1.ger.corp.intel.com> <20110414190012.GA23517@redhat.com> <20110416140813.5c90b1fc@mfleming-mobl1.ger.corp.intel.com> <20110418164513.GA25930@redhat.com> <20110421190332.GA2570@redhat.com> <4DB17CDE.3050603@tilera.com> <20110426203644.GA10177@redhat.com> <20110426203711.GB10177@redhat.com>
In-Reply-To: <20110426203711.GB10177@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/26/2011 4:37 PM, Oleg Nesterov wrote:
> 1. do_hardwall_trap() checks ->sighand != NULL and then takes ->siglock.
>
>    This is unsafe even if the task can't run (I assume it is pinned to
>    the same CPU), its parent can reap the task and set ->sighand = NULL
>    right after this check. Even if the compiler dosn't read ->sighand
>    twice and this memory can't to away __group_send_sig_info() is wrong
>    after that. Use do_send_sig_info().
>
> 2. Send SIGILL to the thread, not to the whole process. Unless it has
>    the handler or blocked this kills the whole thread-group as before.
>    IIUC, different threads can be bound to different rect's.
>
> 3. Check PF_EXITING instead of ->sighand. A zombie thread can go away
>    but its ->sighand can be !NULL.
>
> Reported-by: Matt Fleming <matt@console-pimps.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Thanks, I've taken this change into the tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


