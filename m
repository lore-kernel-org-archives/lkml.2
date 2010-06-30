Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0F3AQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:16:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36115 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab0F3AQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:16:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Cc: kosaki.motohiro@jp.fujitsu.com, Stefani Seibold <stefani@seibold.net>,
       Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Veaceslav Falico <vfalico@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <201006290858.50387.sgrubb@redhat.com>
References: <20100629115957.38BF.A69D9226@jp.fujitsu.com> <201006290858.50387.sgrubb@redhat.com>
Message-Id: <20100630084217.38F2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 09:16:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday, June 28, 2010 11:05:56 pm KOSAKI Motohiro wrote:
> > > Am Freitag, den 25.06.2010, 08:56 +0900 schrieb KOSAKI Motohiro:
> > > > > Through get_task_comm() and many direct uses of task->comm in the
> > > > > kernel, it is possible for escape codes and other non-printables to
> > > > > leak into dmesg, syslog, etc.  In the worst case, these strings
> > > > > could be used to attack administrators using vulnerable terminal
> > > > > emulators, and at least cause confusion through the injection of \r
> > > > > characters.
> > > > > 
> > > > > This patch sanitizes task->comm to only contain printable characters
> > > > > when it is set.  Additionally, it redefines get_task_comm so that it
> > > > > is more obvious when misused by callers (presently nothing was
> > > > > incorrectly calling get_task_comm's unsafe use of strncpy).
> 
> For the audit system, we want the real, unsanitized task->comm. We record it 
> in a special format to the audit logs such that unprintable characters are 
> included. We want it exactly this way for certification purposes as well as 
> forensic evidence if someone was playing games. If you do sanitize it for 
> other areas of the kernel, please give us a way to get the unsanitized text.

Probably this mail is offtopic. I think audit is unrelated with this discusstion. because when 
forensic, admins shouldn't believe task->comm at all. because 1) no path information, 
perhaps "ls" might mean "/home/attackers-dir/evil-script/ls" 2) easily obscured by 
prctl(PR_SET_NAME).

That said, audit have to logged following two point if task name is necessary.
1) exec
2) prctl(PRT_SET_NAME)

Thought ?



