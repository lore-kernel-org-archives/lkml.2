Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1HDLEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 07:04:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:44802 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752910Ab1HDLEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 07:04:47 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18dmrJH0PAdWpwuxtDagbEpT67R3VmROT5v2H7wjn
	7AxNejl4ve3zWj
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: shm updates broke UML
Date: Thu, 4 Aug 2011 13:04:40 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0; KDE/4.6.5; i686; ; )
Cc: Marc Zyngier <marc.zyngier@arm.com>, Richard Weinberger <richard@nod.at>,
        serge.hallyn@canonical.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
References: <201108011541.59640.richard@nod.at> <08cf4697685ecd9bcb7e4eefe516f2ee@localhost> <20110801172452.GA26190@albatros>
In-Reply-To: <20110801172452.GA26190@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108041304.41135.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

issue solved for the UML, tested linux-v3.0-7347-g288d5ab whcih works fine.

BTW is there a special commit id dealing with this bug or was it solved as a 
side effect of another commit ?

Vasiliy Kulikov wrote at 19:24:52
> On Mon, Aug 01, 2011 at 19:19 +0200, Marc Zyngier wrote:
> > Here you go (sorry about the line wrapping, damned webmail...):
> Thank you!  Now I see that the problem is rw_mutex is not initialized:
> 
> 	down_write(&shm_ids(ns).rw_mutex);
> 
> void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
> {
>     ...
> 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
>                                          ^^^^^^^^^^^^^^^ is NULL
> 
> Wtf - ipc namespace should be fully initialized for the moment of
> threads run...
> 
> > Calibrating local timer... 104.99MHz.
> > CPU1: Booted secondary processor
> > CPU1: Unknown IPI message 0x1
> > CPU2: Booted secondary processor
> > CPU2: Unknown IPI message 0x1
> > CPU3: Booted secondary processor
> > CPU3: Unknown IPI message 0x1
> > Brought up 4 CPUs
> > SMP: Total of 4 processors activated (333.41 BogoMIPS).
> > ns = c0447474, ids = c04474d0
> > ns = c0447474, ids = c04474d0
> > wait_list = c04474e0
> > next =   (null)
> 
>            ^^^^^^


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
