Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0LASNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:13:51 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:24898 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751876Ab0LASNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:13:51 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: NHT6By8VM1kQtDawWMQyIrAZm76zCfpCWpZfTkGHJfj0Utp
 KR9lnaMpBF59TCesA268uL9Gb_zyzN9G8IYp9YtrIjvCYrlzsTcpb6IelMhc
 .MHhU9BW3Q2izzuz.ISwNL3S_6EwQVX7FzDmaYWTdHcHp_SsPnutxsZ5nlje
 3GFbLz6inxlbjRdGOj6OstWk7dSrmrH2k0Ic_s47E5XjZHL6MORAOY5Jk7ku
 J9goGX6zRSKwtl575AObs29Jw1qEdBPu0YsZUFcQ-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Dec 2010 12:13:44 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [thisops uV3 08/18] Taskstats: Use this_cpu_ops
In-Reply-To: <1291226786.2898.22.camel@holzheu-laptop>
Message-ID: <alpine.DEB.2.00.1012011212490.3774@router.home>
References: <20101130190707.457099608@linux.com>  <20101130190845.819605614@linux.com> <1291226786.2898.22.camel@holzheu-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Michael Holzheu wrote:

> >  		return -ENOMEM;
> >
> >  	if (!info) {
> > -		int seq = get_cpu_var(taskstats_seqnum)++;
> > -		put_cpu_var(taskstats_seqnum);
> > +		int seq = this_cpu_inc_return(taskstats_seqnum);
>
> Hmmm, wouldn't seq now always be one more than before?
>
> I think that "seq = get_cpu_var(taskstats_seqnum)++" first assigns
> taskstats_seqnum to seq and then increases the value in contrast to
> this_cpu_inc_return() that returns the already increased value, correct?

Correct. We need to subtract one from that (which will eliminate the minus
-1 that the inline this_cpu_inc_return creates).

