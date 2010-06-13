Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab0FMLY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:24:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48216 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0FMLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:24:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/1] signals: introduce send_sigkill() helper
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20100610010023.GB4727@redhat.com>
References: <20100610005937.GA4727@redhat.com> <20100610010023.GB4727@redhat.com>
Message-Id: <20100613184334.6181.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 13 Jun 2010 20:24:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Great.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




