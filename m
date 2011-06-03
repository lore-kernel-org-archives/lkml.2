Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab1FCShe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:37:34 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:12533
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab1FCShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:37:33 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz9371M1418M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 3 Jun 2011 13:37:26 -0500
From: Scott Wood <scottwood@freescale.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Timur Tabi <timur@freescale.com>, <alan@lxorguk.ukuu.org.uk>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
Message-ID: <20110603133726.0e55d27e@schlenkerla.am.freescale.net>
In-Reply-To: <BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
References: <1307119552-15573-1-git-send-email-timur@freescale.com>
	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>
	<4DE92675.6080908@freescale.com>
	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jun 2011 21:26:21 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Fri, Jun 3, 2011 at 9:22 PM, Timur Tabi <timur@freescale.com> wrote:
> > Alexey Dobriyan wrote:
> >> NAK
> >> It accesses userspace data twice.
> >
> > What's wrong with that?
> 
> If mm is shared, data can or will change under you.
>
> > How else is it supposed to know how much to allocate
> > without using strlen first?
> 
> I don't know.
> What I know is that your function doesn't guarantee NUL-termination.

If the only issue is NUL-termination (and I think that's the only issue,
everything else is userspace shooting itself in the foot), just stick
"str[len] = 0" at the end.

-Scott

