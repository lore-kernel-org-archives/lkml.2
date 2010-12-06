Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab0LGF60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 00:58:26 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33565 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0LGF6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 00:58:23 -0500
Date: Mon, 6 Dec 2010 20:02:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 08/18] Taskstats: Use this_cpu_ops
Message-ID: <20101206143256.GE3158@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101130190707.457099608@linux.com>
 <20101130190845.819605614@linux.com>
 <1291226786.2898.22.camel@holzheu-laptop>
 <alpine.DEB.2.00.1012011212490.3774@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012011212490.3774@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [2010-12-01 12:13:44]:

> On Wed, 1 Dec 2010, Michael Holzheu wrote:
> 
> > >  		return -ENOMEM;
> > >
> > >  	if (!info) {
> > > -		int seq = get_cpu_var(taskstats_seqnum)++;
> > > -		put_cpu_var(taskstats_seqnum);
> > > +		int seq = this_cpu_inc_return(taskstats_seqnum);
> >
> > Hmmm, wouldn't seq now always be one more than before?
> >
> > I think that "seq = get_cpu_var(taskstats_seqnum)++" first assigns
> > taskstats_seqnum to seq and then increases the value in contrast to
> > this_cpu_inc_return() that returns the already increased value, correct?
> 
> Correct. We need to subtract one from that (which will eliminate the minus
> -1 that the inline this_cpu_inc_return creates).
>

But that breaks current behaviour, we should probably initialize all
of the array to -1? 

-- 
	Three Cheers,
	Balbir
