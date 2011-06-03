Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab1FCTcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:32:01 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:22640 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751797Ab1FCTcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:32:00 -0400
X-SpamScore: -17
X-BigFish: VS-17(zz9371M1102K1432N98dKzz1202hzz8275bhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 3 Jun 2011 14:31:27 -0500
From: Scott Wood <scottwood@freescale.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Timur Tabi <timur@freescale.com>, <alan@lxorguk.ukuu.org.uk>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
Message-ID: <20110603143127.3c25896e@schlenkerla.am.freescale.net>
In-Reply-To: <BANLkTikmVncMdJhK0Hi6uWeiE_S9TtdhTQ@mail.gmail.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
	<4DE9294B.3040501@freescale.com>
	<BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com>
	<20110603135303.0800e4a7@schlenkerla.am.freescale.net>
	<BANLkTikmVncMdJhK0Hi6uWeiE_S9TtdhTQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 22:12:37 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Jun 3, 2011 at 9:53 PM, Scott Wood <scottwood@freescale.com> wrote:
> > On Fri, 3 Jun 2011 21:39:28 +0300
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >
> >> On Fri, Jun 3, 2011 at 9:34 PM, Timur Tabi <timur@freescale.com> wrote:
> >> > Would it be better if I did this:
> >>
> >> The point is data should cross kernelspace/userspace boundary only once.
> >>
> >
> > Why does it matter, as long as it doesn't hurt the kernel if userspace
> > plays games (i.e. take care of the NUL termination), and it's not a
> > performance problem?
> 
> Because now you're lucky C strings are NUL-terminated.
> If this "idiom" applies to some other case like "validate + copy",
> we have a bug.

It's not an idiom.  It is a simple solution to this particular problem.

> We copy data to kernelspace THEN validate or copy or whatever.
> This is obviously correct and safe.

That doesn't mean that other things are necessarily incorrect or unsafe.
The first access is not validation in this case.

In any case, as it appears there's already a strndup_user() in the kernel,
we'll just use that.  You can "fix" it to do a single userspace access, if
you'd like. :-)

-Scott

