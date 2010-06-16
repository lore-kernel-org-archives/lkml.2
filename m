Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0FPQP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:15:57 -0400
Received: from 101-97.80-90.static-ip.oleane.fr ([90.80.97.101]:50602 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab0FPQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:15:56 -0400
Date: Wed, 16 Jun 2010 18:16:52 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: Do not release pid_ns->proc_mnt too early
Message-ID: <20100616161652.GB16877@hawkmoon.kerlabs.com>
Mail-Followup-To: Pavel Emelyanov <xemul@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Linux Containers <containers@lists.osdl.org>,
	linux-kernel@vger.kernel.org
References: <1276703910-16936-1-git-send-email-louis.rilling@kerlabs.com> <4C18F625.9040107@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4C18F625.9040107@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/10 20:04 +0400, Pavel Emelyanov wrote:
> > +void proc_new_task(struct task_struct *task)
> > +{
> > +	struct pid *pid;
> > +	int i;
> > +
> > +	if (!task->pid)
> > +		return;
> > +
> > +	pid = task_pid(task);
> > +	for (i = 0; i <= pid->level; i++)
> > +		mntget(pid->numbers[i].ns->proc_mnt);
> 
> I feel I'm missing something significant, but this patch breaks
> the mntget/mntput balance. Doesn't it?

Gah. Sorry, the part in proc_flush_task() is missing. Will resend ASAP.

Thanks,

Louis

> 
> > +}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
