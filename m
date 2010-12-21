Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab0LUF61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:58:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab0LUF60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:58:26 -0500
Date: Mon, 20 Dec 2010 21:54:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH][RFC] Always unlock 'tasklist_lock' in
 kernel/exit.c::do_wait()
Message-Id: <20101220215432.af5798d5.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1012202324540.23785@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012202324540.23785@swampdragon.chaosbits.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 23:30:38 +0100 (CET) Jesper Juhl <jj@chaosbits.net> wrote:

> The Coverity checker spotted this. I think it has a point, but I'm not 
> intimate with this code so there could be somethingI'm missing.
> 
> It seems that kernel/exit.c::do_wait() does not always release 
> 'tasklist_lock'.

do_wait_thread() and ptrace_do_wait() will have released tasklist_lock
if they returned non-zero.

