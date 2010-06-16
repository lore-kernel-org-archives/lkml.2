Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0FPKBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:01:06 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59405 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0FPKBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:01:04 -0400
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
In-Reply-To: <20100613152918.GA8024@redhat.com>
References: <20100610010023.GB4727@redhat.com> <20100613152918.GA8024@redhat.com>
Message-Id: <20100616185942.72D2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Jun 2010 19:00:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrew, please drop
> 
> 	signals-introduce-send_sigkill-helper.patch
> 
> I am stupid.
> 
> On 06/10, Oleg Nesterov wrote:
> >
> > Cleanup, no functional changes.
> >
> > There are a lot of buggy SIGKILL users in kernel. For example, almost
> > every force_sig(SIGKILL) is wrong. force_sig() is not safe, it assumes
> > that the task has the valid ->sighand, and in general it should be used
> > only for synchronous signals. send_sig(SIGKILL, p, 1) or
> > send_xxx(SEND_SIG_FORCED/SEND_SIG_PRIV) is not right too but this is not
> > immediately obvious.
> >
> > The only way to correctly send SIGKILL is send_sig_info(SEND_SIG_NOINFO)
> 
> No, SEND_SIG_NOINFO doesn't work too. Oh, can't understand what I was
> thinking about. current is the random task, but send_signal() checks
> if the caller is from-parent-ns.
> 
> > Note: we need more cleanups here, this is only the first change.
> 
> We need the cleanups first. Until then oom-killer has to use force_sig()
> if we want to kill the SIGNAL_UNKILLABLE tasks too.

This definitely needed. OOM-Killer is not racist ;)

Thanks.


