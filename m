Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0F3AZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 20:25:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab0F3AZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 20:25:10 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v2] sanitize task->comm to avoid leaking escape codes
Date: Tue, 29 Jun 2010 20:22:52 -0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.5-124.fc13.x86_64; KDE/4.4.4; x86_64; ; )
Cc: Stefani Seibold <stefani@seibold.net>, Kees Cook <kees.cook@canonical.com>,
       linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
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
References: <20100629115957.38BF.A69D9226@jp.fujitsu.com> <201006290858.50387.sgrubb@redhat.com> <20100630084217.38F2.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100630084217.38F2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006292022.53834.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 29, 2010 08:16:08 pm KOSAKI Motohiro wrote:
> > For the audit system, we want the real, unsanitized task->comm. We record
> > it  in a special format to the audit logs such that unprintable
> > characters are included. We want it exactly this way for certification
> > purposes as well as forensic evidence if someone was playing games. If
> > you do sanitize it for other areas of the kernel, please give us a way
> > to get the unsanitized text.
> 
> Probably this mail is offtopic. I think audit is unrelated with this
> discusstion. because when  forensic, admins shouldn't believe task->comm
> at all. because 1) no path information, perhaps "ls" might mean
> "/home/attackers-dir/evil-script/ls" 2) easily obscured by
> prctl(PR_SET_NAME).

No, its on-topic and we want that information unchanged.


> That said, audit have to logged following two point if task name is
> necessary. 1) exec
> 2) prctl(PRT_SET_NAME)
> 
> Thought ?

The audit system is capable of grabbing that information, too.

-Steve
