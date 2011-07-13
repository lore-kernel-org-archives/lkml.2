Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab1GMMKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:10:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36705 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab1GMMKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:10:43 -0400
Date: Wed, 13 Jul 2011 14:10:38 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, vda.linux@googlemail.com,
        jan.kratochvil@redhat.com, pedro@codesourcery.com, indan@nul.nu,
        bdonlan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] ptrace: dont send SIGSTOP on auto-attach if
 PT_SEIZED
Message-ID: <20110713121038.GJ2872@htj.dyndns.org>
References: <20110708171320.GA26943@redhat.com>
 <20110708171417.GD26943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708171417.GD26943@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 08, 2011 at 07:14:17PM +0200, Oleg Nesterov wrote:
> The fake SIGSTOP during attach has numerous problems. PTRACE_SEIZE
> is already fine, but we have basically the same problems is SIGSTOP
> is sent on auto-attach, the tracer can't know if this signal signal
> should be cancelled or not.
> 
> Change ptrace_event() to set JOBCTL_TRAP_STOP if the new child is
> PT_SEIZED, this triggers the PTRACE_EVENT_STOP report.
> 
> Thereafter a PT_SEIZED task can never report the bogus SIGSTOP.
> 
> Test-case:
...
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks good to me.  For 2 and 3,

 Acked-by: Tejun Heo <tj@kernel.org>

So, yeah, with this change, we're almost there.

Thanks.

-- 
tejun
