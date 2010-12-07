Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0LGOjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:39:12 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:35334 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754118Ab0LGOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:39:11 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Z.BKwK8VM1l.zcfrC2O73Ry_9N_XdSH1xawp7uuHSL1ETX4
 BzAb0Pl5cpd4h_jTmN8UrzSQNcC494snbIITzVrPDIPUBhRA7lWZcQ6sM8Ns
 Ahcpq.O6_TuHEBHyKItJ4Klfi4xQy_TfOvuriROY12bgG9uBykZVmAoXC2Yq
 9op69lXVIZxj8h5bPE_5Ud1VsPdbK6CwypUhNtU8_LGV0B0u4kaf2D9s9X_B
 lAT5DaMvIhT.ZyeRXBS26xIEbw9bG3CifOMqa3XM-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 7 Dec 2010 08:39:06 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>, linux-mm@kvack.org
Subject: Re: [thisops uV3 08/18] Taskstats: Use this_cpu_ops
In-Reply-To: <20101206143256.GE3158@balbir.in.ibm.com>
Message-ID: <alpine.DEB.2.00.1012070838020.25976@router.home>
References: <20101130190707.457099608@linux.com> <20101130190845.819605614@linux.com> <1291226786.2898.22.camel@holzheu-laptop> <alpine.DEB.2.00.1012011212490.3774@router.home> <20101206143256.GE3158@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Balbir Singh wrote:

> > Correct. We need to subtract one from that (which will eliminate the minus
> > -1 that the inline this_cpu_inc_return creates).
> >
>
> But that breaks current behaviour, we should probably initialize all
> of the array to -1?

Not necessary. This_cpu_inc() uses an xadd instruction which retrieves
the value and then increments the memory location. Then it adds 1. The -1
eliminates that add.
