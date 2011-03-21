Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1CURxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:53:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab1CURxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:53:31 -0400
Date: Mon, 21 Mar 2011 13:53:04 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321175304.GM1239@redhat.com>
References: <20110321160135.GA31562@sgi.com>
 <20110321161425.GC23614@elte.hu>
 <4D877C4B.9090602@gmail.com>
 <4D878042.9080708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D878042.9080708@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 07:43:46PM +0300, Cyrill Gorcunov wrote:
> I think Jack might need to setup priority for his notifier, like
> 
> static struct notifier_block uv_dump_stack_nmi_nb = {
> 	.notifier_call	= uv_handle_nmi,
> 	.priority	= NMI_LOCAL_HIGH_PRIOR+1,
> };
> 
> so it would be called before perf nmi. Don, am I right?

Unless they added register to detect the external nmi button has been
pressed this shouldn't work and in fact if you run 'perf' you will
probably trigger stack traces for all the cpus on your first NMI.  That is
what has been explained to me privately.

Cheers,
Don
