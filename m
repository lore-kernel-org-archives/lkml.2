Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab2CTOGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:06:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59134 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284Ab2CTOGx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:06:53 -0400
Message-ID: <1332252387.18960.424.camel@twins>
Subject: Re: [PATCH 04/20] powerpc/mm/fault.c: Port OOM changes to
 do_page_fault
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jimi Xenidis <jimix@pobox.com>,
        Ingo Molnar <mingo@elte.hu>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Date: Tue, 20 Mar 2012 15:06:27 +0100
In-Reply-To: <1332249595-2678-1-git-send-email-consul.kautuk@gmail.com>
References: <1332249595-2678-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 09:19 -0400, Kautuk Consul wrote:
> +#ifd#ifdef CONFIG_PPC_SMLPAR
> +                       if (firmware_has_feature(FW_FEATURE_CMO)) {
> +                               preempt_disable();
> +                               get_lppaca()->page_ins += (1 << PAGE_FACTOR);
> +                               preempt_enable();
> +                       }
> +#end#endif 

That's curious CPP usage....
