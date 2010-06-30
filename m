Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab0F3A2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:28:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55957 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab0F3A2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:28:12 -0400
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
In-Reply-To: <201006292022.53834.sgrubb@redhat.com>
References: <20100630084217.38F2.A69D9226@jp.fujitsu.com> <201006292022.53834.sgrubb@redhat.com>
Message-Id: <20100630092432.3900.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 09:28:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tuesday, June 29, 2010 08:16:08 pm KOSAKI Motohiro wrote:
> > > For the audit system, we want the real, unsanitized task->comm. We record
> > > it  in a special format to the audit logs such that unprintable
> > > characters are included. We want it exactly this way for certification
> > > purposes as well as forensic evidence if someone was playing games. If
> > > you do sanitize it for other areas of the kernel, please give us a way
> > > to get the unsanitized text.
> > 
> > Probably this mail is offtopic. I think audit is unrelated with this
> > discusstion. because when  forensic, admins shouldn't believe task->comm
> > at all. because 1) no path information, perhaps "ls" might mean
> > "/home/attackers-dir/evil-script/ls" 2) easily obscured by
> > prctl(PR_SET_NAME).
> 
> No, its on-topic and we want that information unchanged.

Why?
I think I've described why admins should't see task->comm during forensic. Do you
disagree this? or Do you have another viewpoint?

Can you help us clarify your point?

> > That said, audit have to logged following two point if task name is
> > necessary. 1) exec
> > 2) prctl(PRT_SET_NAME)
> > 
> > Thought ?
> 
> The audit system is capable of grabbing that information, too.

ok. thanks good information :)


