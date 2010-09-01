Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab0IAUGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 16:06:04 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:41765 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753055Ab0IAUGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 16:06:01 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hoUaBxwVM1n5od.JZkfS5vzFkJxpTSu1fRuV9graQiMmBmh
 9srQp.GLMROEv2rI7SfFM63HDzz13TpmMgj2ZMWaAxeO.FbV7EiYVhX.pfE_
 UZEFUdMx0TcpGznqL3HRAc7V9riSwcrCOxCIAKKmesgMbIw0vTsuNV05yESU
 W0i26WU.P_DNGo8rjxIVnf7I99vaQew9E7UqJuL7KHGg7AvkLawcVo_ujAQG
 6eeGk4Df93zUEoJkejtkXCmUMFBJ5
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 1 Sep 2010 15:05:54 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] Use percpu stats
In-Reply-To: <1283290878.2198.28.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1009011501230.16013@router.home>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>  <1281374816-904-4-git-send-email-ngupta@vflare.org>  <alpine.DEB.2.00.1008301114460.10316@router.home>  <AANLkTikdhnr12uU8Wp60BygZwH770RBfxyfLNMzUsQje@mail.gmail.com>  <1283290106.2198.26.camel@edumazet-laptop>
  <alpine.DEB.2.00.1008311635100.867@router.home> <1283290878.2198.28.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Eric Dumazet wrote:

> > > Even for single counter, this_cpu_read(64bit) is not using an RMW
> > > (cmpxchg8) instruction, so you can get very strange results when low
> > > order 32bit wraps.
> >
> > How about fixing it so that everyone benefits?
> >
>
> IMHO, this_cpu_read() is fine as is : a _read_ operation.
>
> Dont pretend it can be used in every context, its not true.

The problem only exists on 32 bit platforms using 64 bit counters. If you
would provide this functionality for the fallback case of 64 bit counters
(here x86) in 32 bit arch code then you could use the this_cpu_*
operations in all context without your special code being replicated in
ohter places.

The additional advantage would be that for the 64bit case you would have
much faster and more compact code.


