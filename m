Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0LJTv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 14:51:27 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:47500 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756066Ab0LJTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 14:51:26 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7TzaYZ8VM1n9uQtdLlhTKYs0_xTsFk4kp3Q3reejTDZN0uk
 mRCG9tGmxFKIrqGrCQA6J68t1IxrR4PF9OZVdcpLKjOvNuBQZh4D8C3psKSY
 tjWIRGZ7_jQrJ7Jz9MuugZK6dyQ.IC1Acew.7u9iN88sO5wlt4yz7kabTZ5K
 ZTzqZTHC8mBc7pO9bYcJPdD.X571ljJvnuVnOvfLVXeXQo3nm16tNCRavT8z
 EkZtv2wEdxG2Q_OS4sYyUcbf4atcP_6FMrBMgv8FlYNAKOgtLspQHqMKnrbh
 UmsibBs9SW33CgX5v7dpe8WW3t6PfhWIihAzADj28cm6JX4Y-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 10 Dec 2010 13:51:23 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
In-Reply-To: <1292006788.13513.43.camel@laptop>
Message-ID: <alpine.DEB.2.00.1012101344570.13986@router.home>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>  <1291851079-27061-1-git-send-email-venki@google.com>  <1291899120.29292.7.camel@twins>  <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>  <1291917330.6803.7.camel@twins> 
 <AANLkTin+eO_jPceSOHL4e7vqd+tf0ZCMHJ-USoz8aZL1@mail.gmail.com>  <1291920939.6803.38.camel@twins>  <AANLkTim+v21RpWobdw6exEbazDJwm4JjemPVB2+3PuRJ@mail.gmail.com>  <1291936593.13513.3.camel@laptop>  <AANLkTi=_qf8NAgj2HHMP0qG-ibnH-726NzoXbxd-bS1N@mail.gmail.com>
  <1291975704.6803.59.camel@twins>  <1291987065.6803.151.camel@twins>  <1291987635.6803.161.camel@twins>  <1291988866.6803.171.camel@twins>  <1292001500.3580.268.camel@edumazet-laptop>  <1292003346.13513.30.camel@laptop>  <1292004859.3580.387.camel@edumazet-laptop>
  <alpine.DEB.2.00.1012101236300.13986@router.home> <1292006788.13513.43.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010, Peter Zijlstra wrote:

> > > gcc wont be able to do this yet (%fs/%gs selectors)
> >
> > The kernel can do that using the __percpu annotation.
>
> That's not true:
>
> # define __percpu
>
> Its a complete NOP.

The annotation serves for sparse checking. .... If you do not care about
those checks then you can simply pass a percpu pointer in the same form as
a regular pointer.

> > > But we can provide this_cpu_write_seqcount_{begin|end}()
> >
> > No we cannot do hat. this_cpu ops are for per cpu data and not for locking
> > values shared between processors. We have a mechanism for passing per cpu
> > pointers with a corresponding annotation.
>
> -enoparse, its not locking anything, is a per-cpu sequence count.

seqlocks are for synchronization of objects on different processors.

Seems that you do not have that use case in mind. So a seqlock restricted
to a single processor? If so then you wont need any of those smp write
barriers mentioned earlier. A simple compiler barrier() is sufficient.





