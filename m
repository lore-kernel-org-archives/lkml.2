Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab0FYTbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab0FYTbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:31:43 -0400
Date: Fri, 25 Jun 2010 21:29:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] pid_ns: Fix proc_flush_task() accessing freed
	proc_mnt
Message-ID: <20100625192945.GA25532@redhat.com>
References: <20100623203652.GA25298@redhat.com> <1277399329-18087-1-git-send-email-louis.rilling@kerlabs.com> <20100624191843.GA14205@redhat.com> <20100625102303.GG3773@hawkmoon.kerlabs.com> <20100625183733.GA2627@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625183733.GA2627@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Sukadev Bhattiprolu wrote:
>
> Louis Rilling [Louis.Rilling@kerlabs.com] wrote:
> | - proc_pid_readdir():
> |   Needs similar check and protection to proc_pid_lookup(), but there is another
> |   issue: next_tgid() can find a dying task:
>
> Hmm, I thought proc_pid_readdir() would be a problem too but convinced myself
> that it would not - since a process running proc_pid_readdir() would have
> a reference to the pid namespace,

Where does this reference comes from ?

proc_pid_readdir() pins the task_struct (ns->child_reaper), not the pid/ns.

But I won't be surprised if I am wrong again ;)

Oleg.

