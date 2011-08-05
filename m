Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1HERBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:01:45 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32309 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751190Ab1HERBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:01:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: nYEaQ3IVM1k_wI0FdObhYzbBNCJx8ixWi9mPgTbYJ9wO0FO
 WqxEtuJqfQFLWD0PM53n00wxWUSPV.TYS8sLtY.xjRtHMHd9aMvrUlJT_Xgl
 a6jTUtM977MZBxdTHmdnOHuLbdcD4aAHisQza_baGgcQZllz3yHP14oyIRtl
 ewo0w0yjJLqtpqVjpkm5miSl743mYzzBPm75ppgfwAJeb.bvuUjUEHTakWTD
 6luwgnv5wHyf9sPJwVZjJJ4VpevoXg0x8BrkePtqfe_y.GK3mphHx.y.J05I
 HrrK0Eelz_vsVdOObihQ1Lx2QxOmH.z3Fur9Ss1MqPaXcf7d9UjAMvYtSFJB
 NjRrrt6222UGa_q38LC_cZC4xCLn9zZX5JapT..9gP5oGH0ceLjGj5UVOqee
 k2tMu7wnKPd7h.U42c0tTmg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 5 Aug 2011 12:01:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Dave Jones <davej@redhat.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
In-Reply-To: <20110805165119.GA11593@redhat.com>
Message-ID: <alpine.DEB.2.00.1108051158400.28580@router.home>
References: <20110805010038.GA18148@redhat.com> <20110805084614.GA1588@x4.trippels.de> <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com> <alpine.DEB.2.00.1108051131440.28580@router.home> <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home> <20110805165119.GA11593@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Aug 2011, Dave Jones wrote:

> On Fri, Aug 05, 2011 at 11:47:56AM -0500, Christoph Lameter wrote:
>  > On Fri, 5 Aug 2011, Dave Jones wrote:
>  >
>  > > Not sure if you were addressing my original report (quoted above), or the networking
>  > > related report in this part of the thread. But anyway, I had it turned on (as well as just about
>  > > every other debugging option).  I didn't see anything output from it though,
>  > > just the LIST_DEBUG warnings.
>  >
>  > But CONFIG_SLUB_DEBUG_ON was off? If slab debugging was on then this could
>  > be an issue with full slab list management instead of partial lists.
>
> $ grep SLUB_DEBUG_ON .config
> CONFIG_SLUB_DEBUG_ON=y

Argh another debugging code issue. Anyone who sees this please verify that
it also occurs with debugging off. I ran this code for 9 months in
various configs but only sporadically with debugging support since that
switches the lockless stuff. With the lockless ops on we cannot
establish a stable state of the object as needed for regular inspection
and verification of operations.


