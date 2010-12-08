Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0LHUFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:05:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47405 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab0LHUFS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:05:18 -0500
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>
In-Reply-To: <1291838420.28378.159.camel@laptop>
References: <20101202144129.4357fe00@annuminas.surriel.com>
	 <20101202144423.3ad1908d@annuminas.surriel.com>
	 <1291382619.32004.2124.camel@laptop>  <4CFFC68D.30506@redhat.com>
	 <1291838420.28378.159.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 21:04:57 +0100
Message-ID: <1291838697.28378.161.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 21:00 +0100, Peter Zijlstra wrote:
> +       lag0 = avg_vruntime(cfs_rq_of(se));
> +       p_lag0 = avg_vruntime(cfs_rq_of(p_se));
> +
> +       lag = se->vruntime - avg_vruntime(cfs_rq);
> +       p_lag = p_se->vruntime - avg_vruntime(p_cfs_rq);
> +
> +       if (p_lag > lag) { /* if P is owed less service */
> +               se->vruntime = lag0 + p_lag;
> +               p_se->vruntime = p_lag + lag;
> +       } 

clearly that should read:

  p_se->vruntime = p_lag0 + lag;
