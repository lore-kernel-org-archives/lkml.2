Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993Ab0FKApS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:45:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52603 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0FKApQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:45:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Jun 2010 09:40:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 1/1] signals: introduce send_sigkill() helper
Message-Id: <20100611094045.8f6e5218.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100610010023.GB4727@redhat.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
	<20100608210000.7692.A69D9226@jp.fujitsu.com>
	<20100608184144.GA5914@redhat.com>
	<20100610005937.GA4727@redhat.com>
	<20100610010023.GB4727@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 03:00:23 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Cleanup, no functional changes.
> 
> There are a lot of buggy SIGKILL users in kernel. For example, almost
> every force_sig(SIGKILL) is wrong. force_sig() is not safe, it assumes
> that the task has the valid ->sighand, and in general it should be used
> only for synchronous signals. send_sig(SIGKILL, p, 1) or
> send_xxx(SEND_SIG_FORCED/SEND_SIG_PRIV) is not right too but this is not
> immediately obvious.
> 
> The only way to correctly send SIGKILL is send_sig_info(SEND_SIG_NOINFO)
> but we do not want to use this directly, because we can optimize this
> case later. For example, zap_pid_ns_processes() allocates sigqueue for
> each process in namespace, this is unneeded.
> 
> Introduce the trivial send_sigkill() helper on top of send_sig_info()
> and change zap_pid_ns_processes() as an example.
> 
> Note: we need more cleanups here, this is only the first change.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

