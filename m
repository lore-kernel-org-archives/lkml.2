Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab1FPQPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:15:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1FPQPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:15:39 -0400
Date: Thu, 16 Jun 2011 18:12:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kurz <gkurz@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Cedric Le Goater <clg@vnet.ibm.com>, linux-kernel@vger.kernel.org,
        containers@lists.osdl.org, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
	Vpid:)
Message-ID: <20110616161252.GA3189@redhat.com>
References: <20110615145527.4016.70157.stgit@bahia.local> <20110615190302.GA16440@redhat.com> <1308223158.8230.66.camel@bahia.local> <4DF9F657.7030605@fr.ibm.com> <m1y611bysa.fsf@fess.ebiederm.org> <1308238412.8230.95.camel@bahia.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308238412.8230.95.camel@bahia.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16, Greg Kurz wrote:
>
> @@ -183,12 +183,14 @@ static inline void task_state(struct seq_file *m,
> struct pid_namespace *ns,
>  		"Pid:\t%d\n"
>  		"PPid:\t%d\n"
>  		"TracerPid:\t%d\n"
> +		"ActivePid:\t%d\n"
>  		"Uid:\t%d\t%d\t%d\t%d\n"
>  		"Gid:\t%d\t%d\t%d\t%d\n",
>  		get_task_state(p),
>  		task_tgid_nr_ns(p, ns),
>  		pid_nr_ns(pid, ns),
>  		ppid, tpid,
> +		pid_nr_ns(pid, ns_of_pid(pid)),

Indeed, I forgot that we already have task_pid() in the arguments.

Oleg.

