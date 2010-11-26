Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0KZRCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:02:50 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:47767 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752204Ab0KZRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:02:49 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: U8DS0IMVM1m5ZjWPsG_a1.BJ6G0RGpoO7isZYAUHtyaZ_3y
 ZiB4UNgZMinHEqLxzIGPimgFmPm4b1ZO1kReWV4X76zl.KSgkoo_ceW0Nyr_
 gghs4Itgo7eGZ5QrAhxTtTULrWOyEtwVbcY4CGg6ZLSs6fm_Bxccmx5fHrdt
 EMhb9cqd5rLr4_O61KGtABEaZWd5iiN0LuR7f5XcdkjGG34KpDMSYSsaGXCY
 iY8gv_LnGb6Y-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 26 Nov 2010 11:02:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 05/10] x86: Use this_cpu_inc_return for nmi
 counter
In-Reply-To: <4CEFE1CB.4050404@kernel.org>
Message-ID: <alpine.DEB.2.00.1011261047460.13524@router.home>
References: <20101123235139.908255844@linux.com> <20101123235158.826005750@linux.com> <4CEFE1CB.4050404@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Tejun Heo wrote:

> > -		__this_cpu_inc(alert_counter);
> > -		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
> > +		if (__this_cpu_inc_return(alert_counter) == 5 * nmi_hz)
>
> Hmmm... one worry I have is that xadd, being not a very popular
> operation, might be slower than add and read.  Using it for atomicity
> would probably be beneficial in most cases but have you checked this
> actually is cheaper?

XADD takes 3 uops. INC 1 and MOV 1 uop. So there is an additiona uop.

However, a memory fetch from l1 takes a mininum 4 cycles. Doing that twice
already ends up with at least 8 cycles.




