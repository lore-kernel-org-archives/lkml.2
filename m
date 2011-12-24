Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1LXHnC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 02:43:02 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:46880 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752773Ab1LXHnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 02:43:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/qU4VtyeXqf3mNQ73KGpCUtzZOZRPEPB60IrgdZF
	MbvKtRmPOyl0HC
Subject: Re: Commit 1e5a74059f9 broke utime measurement of ptraced()
 processes
From: Mike Galbraith <efault@gmx.de>
To: =?UTF-8?Q?=D0=90=D1=80=D1=82=D0=B5=D0=BC_?=
	 =?UTF-8?Q?=D0=90=D0=BD=D0=B8=D1=81=D0=B8=D0=BC=D0=BE=D0=B2?= 
	<aanisimov@inbox.ru>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu
In-Reply-To: <201112241026.35726.aanisimov@inbox.ru>
References: <201112191519.40901.aanisimov@inbox.ru>
	 <1324388358.8497.20.camel@marge.simson.net>
	 <201112241026.35726.aanisimov@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Dec 2011 08:42:46 +0100
Message-ID: <1324712566.5025.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-24 at 10:26 +0300, Артем Анисимов wrote:

>   I believe that the described behaviour is erroneous and in order to
> > lessen the odds of it [waker] being preempted again soon
> one should not mess with utime but rather use another technique. It is also 
> interesting why the *user time* needs to be affected? It is inside the kernel 
> that the tracer process is woken up, so when
> > handing a few wakeup expense cycles to the wakee
> why not account those cycles as stime?

CPU utilization shifts with wakeup preemption, so there will be visible
effect when you change wakeup preemption in any way.

>   Also I'd like to know if there is a way to get reliable utime measurements 
> in recent kernels.

If wakeup preemption is undesirable, you could run SCHED_BATCH.

	-Mike

