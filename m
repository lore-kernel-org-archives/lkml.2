Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0IPFwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:52:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46399 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab0IPFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:51:59 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] execve: check the VM has enough memory at first
Cc: kosaki.motohiro@jp.fujitsu.com, Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
        linux-fsdevel@vger.kernel.org, pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100914105147.C996.A69D9226@jp.fujitsu.com>
References: <AANLkTik=ZpiCN-5YfWJ6zejSJBknL8Sj4Vtc+X_XpS71@mail.gmail.com> <20100914105147.C996.A69D9226@jp.fujitsu.com>
Message-Id: <20100916111714.CA03.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Sep 2010 14:51:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Wed, Sep 8, 2010 at 10:04 PM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > >
> > > After this patch, execve() expand stack at first and receive to
> > > check vm_enough_memory() properly. then, too long argument of
> > > execve() than the machine memory return EFAULT properly.
> > 
> > This is horrible. We don't want to walk the arguments one more time
> > just for this. Let's just improve the checks that we do as we go
> > along.
> > 
> >                             Linus
> 
> Okey. I'll consider new way in this night.

After while thinking, I decided to just drop this idea. because
 1) If one pass check is must, we can't reuse vm-overcommit check.
 2) Glibc has the duplicated hueristic, then we can't change it nor
    introduce new hard limit. (Sh*t)
 3) This is not must fix, it only mitigate a pain when accidental large
    argv case. Only OOM fixes enough care intended attack case.
 4) distro can change default of rlim_max of RLIMIT_STACK. It protect
    from RLIM_INFINITY smash.

Briefly says, to introduce new limit has bad benefit/risk balance. Sadly.



