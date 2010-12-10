Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab0LJVpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:45:22 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:31653 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753965Ab0LJVpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:45:20 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: v_KbOSIVM1l9.EOE7g1TUAqUI.LlUkN4dREd6z75703tY0n
 ydbmuXtOJwS8A2aBhGpc4G09nInrM4oygbG6D18daPGN.RSGL_T0DOqkixy.
 Z.aMIHspgTBTpejZZhRNfB5sr0_7n3u71g8XUQkcUFe9mpfN3fRnlMOt1CM8
 DBs7qWOyAq2AOhkDmZZjy28muWU_ZuvplDSFthHPL_gOL_FhEa2.S36hZFY2
 D.u8HfcsPA89_Mn4Dtz1GAdxfslJR3arHYFFarGPG7X7faQqk75H9IUuc1dW
 gcGxD35E1I8MK8IHobfbQxavED.l9AtuDJkzc9dOWLUc33Mw-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 10 Dec 2010 15:45:15 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
In-Reply-To: <1292016165.2746.14.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1012101533400.13986@router.home>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>  <1291851079-27061-1-git-send-email-venki@google.com>  <1291899120.29292.7.camel@twins>  <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>  <1291917330.6803.7.camel@twins> 
 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>  <1291920939.6803.38.camel@twins>  <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>  <1291936593.13513.3.camel@laptop>  <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
  <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>  <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>  <1292001500.3580.268.camel@edumazet-laptop>  <1292003346.13513.30.camel@laptop>  <1292004859.3580.387.camel@edumazet-laptop>
  <alpine.DEB.2.00.1012101236300.13986@router.home>  <1292006788.13513.43.camel@laptop>  <alpine.DEB.2.00.1012101344570.13986@router.home>  <1292011644.13513.61.camel@laptop>  <alpine.DEB.2.00.1012101410571.13986@router.home>  <1292013590.2746.2.camel@edumazet-laptop>
  <1292014165.2746.9.camel@edumazet-laptop>  <alpine.DEB.2.00.1012101505250.13986@router.home> <1292016165.2746.14.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Eric Dumazet wrote:

> > There is certainly a major difference in that execution of a stream of
> > instructions on the same cpu is guaranteed to have a coherent view of
> > the data. That is not affected by interrupts etc.
> >
>
> We dont care of interrupts. We care of doing a transaction over a
> complex set of data, that cannot be done using an atomic op (or we need
> a spinlock/mutex/rwlock), and should not because of performance.

So what? The cpu gives you incoherent view of data somewhere when only
processing data from a single cpu?

If you have remote data accesses (loop summing the data?) and you have to
be concerned about data coherence then you CANNOT use this_cpu_ops since
they are not guaranteed to be coherent to other processors.
