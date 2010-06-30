Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0F3Abf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:31:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37016 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0F3Abd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:31:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Cc: kosaki.motohiro@jp.fujitsu.com, Kees Cook <kees.cook@canonical.com>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Veaceslav Falico <vfalico@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Stefani Seibold <stefani@seibold.net>,
       Thomas Gleixner <tglx@linutronix.de>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Steve Grubb <sgrubb@redhat.com>,
       Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100629103650.3b80e09f@lxorguk.ukuu.org.uk>
References: <20100624190527.GD5917@outflux.net> <20100629103650.3b80e09f@lxorguk.ukuu.org.uk>
Message-Id: <20100630092828.3903.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 09:31:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch sanitizes task->comm to only contain printable characters
> > when it is set.  Additionally, it redefines get_task_comm so that it is
> > more obvious when misused by callers (presently nothing was incorrectly
> > calling get_task_comm's unsafe use of strncpy).
> 
> This is a regression for tools that correctly handle unmutilated data.
> 
> > +	/* sanitize non-printable characters */
> > +	for (i = 0; buf[i] && i < (sizeof(tsk->comm) - 1); i++) {
> > +		if (!isprint(buf[i]))
> > +			tsk->comm[i] = '?';
> 
> The kernel "isprint" isn't adequate for this. comm is set by the shell
> based on argv[0] usually which means that in normal situations it is a
> UTF-8 string.

Ah, I recall one use case. In past, some IBM folks talked about they
want to map Java thread name to prctl(PR_SET_NAME). In such case, 
utf-8 name is very common.

So, I agree with you.

Thanks.



