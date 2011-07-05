Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab1GERrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:47:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38641 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab1GERrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:47:46 -0400
Message-ID: <4E134E1E.6040304@zytor.com>
Date: Tue, 05 Jul 2011 10:47:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Q x86-64] on kernel_eflags
References: <20110705104742.GO17941@sun>
In-Reply-To: <20110705104742.GO17941@sun>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 03:47 AM, Cyrill Gorcunov wrote:
> 
> Should not every cpu has own copy of kernel_eflags? Just
> to be consistent in style? Or this would be space waisting
> and an optimization is done here?
> 

Not specific to this particular case, but in general: a shared variable
that used often but rarely written to will automatically replicate
itself in the caches of multiple processors.  This is the purpose of the
read_mostly segment (writes are permitted but expected to be rare),
which exists to make sure that a frequently written variable doesn't
randomly end up in the cache line next to a read-mostly variable.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

