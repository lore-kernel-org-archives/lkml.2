Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab0LFRf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:35:28 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:27568 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752162Ab0LFRf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:35:27 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Drk3zoIVM1me5opdZ3y7xoyPLTEluFmSLVVXN8H5UmTlEfk
 OvgB.6S0mU7ZoHSF2XrLjzn5M5KhxxHQXmlIfbMjXAHlOVu6vtjHD1Qyqsbn
 Hufm9moIkX4KtXLZOGzf6oX7d73Pc2HLytVM2JlRPAya0uRauqGdO7_2GPCh
 JB7UlSESu.bcVQbzbqciiqMMkbuNRTebO69Ji5sIA8dYo47zb0jcwDEt.NxN
 EQchm4OvBC1I-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Dec 2010 11:35:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Avi Kivity <avi@redhat.com>
cc: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [rfc: cpuops adv V1 3/8] x86: this_cpu_cmpxchg and
 this_cpu_cmpxchg_double operations
In-Reply-To: <4CFD1A05.3020900@redhat.com>
Message-ID: <alpine.DEB.2.00.1012061134170.2866@router.home>
References: <20101202215340.562309713@linux.com> <20101202215400.609058574@linux.com> <4CFD1A05.3020900@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Avi Kivity wrote:

> On 12/02/2010 11:53 PM, Christoph Lameter wrote:
> > Provide support as far as the hardware capabilities of the x86 cpus
> > allow.
> >
> >
> >
> > +/*
> > + * Beware: xchg on x86 has an implied lock prefix. There will be the cost
> > of
> > + * full lock semantics even though they are not needed.
> > + */
>
> Perhaps we can use cmpxchg instead of xchg to avoid this? costs one more
> instruction but may be worth it.

Hmmm... Maybe good since I also need a xchg_double. And xchg_double can
only be realized with cmpxchg16b. Using cmpxchg would make it consistent.


