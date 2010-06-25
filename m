Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0FYVPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:15:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54558 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab0FYVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:15:09 -0400
Date: Fri, 25 Jun 2010 14:26:18 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] pid_ns: Fix proc_flush_task() accessing freed
	proc_mnt
Message-ID: <20100625212618.GA11917@us.ibm.com>
References: <20100623203652.GA25298@redhat.com> <1277399329-18087-1-git-send-email-louis.rilling@kerlabs.com> <20100624191843.GA14205@redhat.com> <20100625102303.GG3773@hawkmoon.kerlabs.com> <20100625183733.GA2627@us.ibm.com> <20100625192945.GA25532@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625192945.GA25532@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov [oleg@redhat.com] wrote:
| On 06/25, Sukadev Bhattiprolu wrote:
| >
| > Louis Rilling [Louis.Rilling@kerlabs.com] wrote:
| > | - proc_pid_readdir():
| > |   Needs similar check and protection to proc_pid_lookup(), but there is another
| > |   issue: next_tgid() can find a dying task:
| >
| > Hmm, I thought proc_pid_readdir() would be a problem too but convinced myself
| > that it would not - since a process running proc_pid_readdir() would have
| > a reference to the pid namespace,
| 
| Where does this reference comes from ?

Caller of proc_pid_readdir() would be living in the same pid namespace right ?
i.e the pid namespace is not empty.  If not they would be accessing a different
instance of /proc -no ?

Hmm, but thinking some more, if pid ns is created but /proc not
remounted, the process would be accessing the parent ns (which cannot go
away).

A process cannot access a descendant/unrelated pid namespaces's /proc right ?

| 
| proc_pid_readdir() pins the task_struct (ns->child_reaper), not the pid/ns.
| 
| But I won't be surprised if I am wrong again ;)
| 
| Oleg.
