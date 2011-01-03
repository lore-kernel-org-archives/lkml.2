Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1ACWnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 17:43:31 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:35157 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751001Ab1ACWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 17:43:30 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: tlN5iM4VM1m2zr.wEdqi2S2g_VgE6sEnSly1XrLFmvPA_jR
 gWjB4m2jDrTFgISPOpBsNtpRCho0OfQBBJan2e.bc4C_7pxSrPW8baDi.1qX
 gE1rrK3t_3FO1VDsFzPFWBB6YblbjILxnSCmllkOpfhxqvayvA3kj4rSOTAh
 6b8_w_98tixf.YWOrdq96f7qL27DTdscXblBNXDe4mqXvxRB_TxwbgUfGJwv
 k1TRZ0ATAdA0eBG0uWcgoED7Ei3lWBKOznJNbzAnwJ6bYQ1JsZJevpipMD65
 C7ppuZFhpcm7ByMNHe7bBsYMJuaWOiKznopQqikgwtEwudq0-
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 3 Jan 2011 16:43:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20101227105203.GE11419@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101031640380.31274@router.home>
References: <20101214174900.058235985@linux.com> <4D0CC982.3030905@kernel.org> <alpine.DEB.2.00.1012211634560.3769@router.home> <4D11373D.9010205@zytor.com> <20101222091358.GC27861@htj.dyndns.org> <alpine.DEB.2.00.1012231812280.22549@router.home>
 <4D13E7D5.7020503@zytor.com> <alpine.DEB.2.00.1012242251090.23107@router.home> <AANLkTikSwwMtDwx4wGM8hO4riZFVmtkq_bihVvPirO8F@mail.gmail.com> <alpine.DEB.2.00.1012251753530.8506@router.home> <20101227105203.GE11419@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Dec 2010, Tejun Heo wrote:

> On Sat, Dec 25, 2010 at 05:55:22PM -0600, Christoph Lameter wrote:
> > On Sat, 25 Dec 2010, Tejun Heo wrote:
> >
> > > ABI.  But that said, it might still be problematic on other
> > > architectures when we try to apply it to different architectures.  Is
> > > everyone against just taking a scalar for the first variable instead
> > > of taking a pointer?  I'd be happier with that than the current one.
> >
> > How about replacing that with two scalars? Macro will check that the
> > scalaers are properly aligned and that the second follows the first. Then
> > there is also better symmetry in the parameters.
> >
> > bool this_cpu_cmpxchg_double(
> >           percpu_1, percpu_2
> >           old_1, old_2
> >           new_1, new_2
> > )
>
> Yeah, maybe.  The interface is a bit redundant but probably the most
> fool proof.  I'm okay with either taking a single scalar or both.

The single large 128 bit scalar does not work. Having to define an
additional structure it also a bit clumsy. I think its best to get another
patchset out that also duplicates the first parameter and makes the percpu
variable specs conform to the other this_cpu ops.

Still on vacation so it may take to the end of the week for me to get this
done.

