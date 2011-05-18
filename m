Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab1ERNCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:02:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab1ERNCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:02:04 -0400
Date: Wed, 18 May 2011 15:00:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/3] coredump: use get_task_comm for %e filename
	format
Message-ID: <20110518130004.GA10638@redhat.com>
References: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay,

On 05/12, Jiri Slaby wrote:
>
> We currently access current->comm directly. As we have
> prctl(PR_SET_NAME), we need the access be protected by task_lock. This
> is exactly what get_task_comm does, so use it.
>
> I'm not 100% convinced prctl(PR_SET_NAME) may be called at the time of
> core dump,

It can't be called. Apart from current, a sub-thread can change ->comm[]
via /proc/pid/comm, but we already killed all threads.

> but the locking won't hurt.

Agreed, the patch looks correct. but still unneeded.

Oleg.

