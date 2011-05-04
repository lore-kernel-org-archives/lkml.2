Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab1EDUdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:33:03 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:41335 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751126Ab1EDUdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:33:01 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: enLLWPoVM1ltqiQ6Jd3ULUFl1.vEbxXifEZqjS3PxprAn0r
 ST8jIT6dDhIDANzIUGJrfGdP4bVhYGCVycLrMzERS1Bcj7JMjmpJbRXUDNim
 P50E5MO5vl6M56y4yjMWsyhG0Jy78hqrdWeFfk2ryjY_ivZwsUPD00R.cdqy
 B41oKbZI2g8hPXKBcTfPzyznUzcK2UZaCEUpnkgqAaP.etEuWCSYVafwtFP0
 AoKpidSVOMP4xJU7EIw6lfA_Kag88A.PPJqpHx8TjoirJw2ZzRidr4Wgw.pB
 6hTIsu7a2B1cm.Cg6syLrC1RWVHIDH03OO9ns6bd1A8_HXq2i
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 May 2011 15:32:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Valdis.Kletnieks@vt.edu
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
In-Reply-To: <19422.1304540499@localhost>
Message-ID: <alpine.DEB.2.00.1105041530210.5495@router.home>
References: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com> <BANLkTinxe=gSERoOHOohb1V-CZ0c9BSy2Q@mail.gmail.com> <20110504112746.GE8007@htj.dyndns.org> <alpine.LFD.2.02.1105041417330.3005@ionos> <20110504132022.GA17294@htj.dyndns.org>
 <alpine.LFD.2.02.1105041539050.3005@ionos> <20110504142532.GC17294@htj.dyndns.org> <alpine.LFD.2.02.1105041640020.3005@ionos> <alpine.DEB.2.00.1105040958570.5495@router.home> <BANLkTikiAqcJVoJRJ6oy+LwPJPz+mHNj_w@mail.gmail.com> <alpine.DEB.2.00.1105041023070.5495@router.home>
 <BANLkTik52Fi=vHY-TiK6SAYrWjaSN=PB+g@mail.gmail.com> <BANLkTimdL_tAONUWxZ4sQn1AiPDdbdYqpw@mail.gmail.com> <BANLkTinLn-59oisLrvwyCvyUuNyDKVHP0g@mail.gmail.com> <alpine.DEB.2.00.1105041341550.5495@router.home> <BANLkTikEgDGt+KrBsZcinKVom5E63Ma6gg@mail.gmail.com>
 <alpine.DEB.2.00.1105041421280.5495@router.home> <BANLkTi=efcVkGb+DReZ+i1p5j4QXJYjKjQ@mail.gmail.com>            <alpine.DEB.2.00.1105041454190.5495@router.home> <19422.1304540499@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Valdis.Kletnieks@vt.edu wrote:

> On Wed, 04 May 2011 15:04:39 CDT, Christoph Lameter said:
> > On Wed, 4 May 2011, Linus Torvalds wrote:
>
> > > But cmpxchg DOES NOT MAKE SENSE without atomicity guarantees.
> >
> > This is not a real cmpxchg after all. Its not atomic in the sense of
> > other functions. Its only "percpu atomic" if you want it that way. This is
> > *not* a full cmpxchg_double().
>
> Calling it a cmpxchg when it doesn't have the primary distinguishing property
> of a hardware cmpxchg is just loading a bullet in the chamber and inviting
> kernel hackers to point it at their feet...

It does have most of the distinguishing characterstics but the
lock-prefixless cmpxchg8b/16b (which is quite fast) is used in a
unique way here in a percpu fastdpath. Thats why we have the strange
naming this_cpu_cmpxchg_double etc.



