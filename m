Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2BJQE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:04:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932300Ab2BJQE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:04:26 -0500
Date: Fri, 10 Feb 2012 16:57:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] ptrace: make PTRACE_SEIZE set ptrace options
	specified in 'data' parameter
Message-ID: <20120210155753.GA25923@redhat.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com> <1328884991-23889-2-git-send-email-vda.linux@googlemail.com> <1328884991-23889-3-git-send-email-vda.linux@googlemail.com> <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Denys Vlasenko wrote:
>
> @@ -879,7 +890,7 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsigned long, addr,
>  	}
>
>  	if (request == PTRACE_ATTACH || request == PTRACE_SEIZE) {
> -		ret = ptrace_attach(child, request, data);
> +		ret = ptrace_attach(child, request, addr, data);

There is another caller which should be updated, sys_compat_ptrace().

Otherwise looks good.

Oleg.

