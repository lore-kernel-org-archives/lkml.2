Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab0JTDsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:48:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab0JTDsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:48:51 -0400
Message-ID: <4CBE6791.9040402@cn.fujitsu.com>
Date: Wed, 20 Oct 2010 11:52:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rcu,cleanup: simplify the code when cpu is dying
References: <4CBD4F56.2000601@cn.fujitsu.com> <20101019183216.GC2362@linux.vnet.ibm.com>
In-Reply-To: <20101019183216.GC2362@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 02:32 AM, Paul E. McKenney wrote:

>  		   rsp->n_force_qs, rsp->n_force_qs_ngp,
>  		   rsp->n_force_qs - rsp->n_force_qs_ngp,
> -		   rsp->n_force_qs_lh);
> +		   rsp->n_force_qs_lh, rsp->orphan_qlen);
>  	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
>  		if (rnp->level != level) {
>  			seq_puts(m, "\n");
> 
> 

rsp->orphan_qlen is still removed in new patch, is it a big problem for
users who trace rcu by these files?

