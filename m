Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0JOTSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:18:43 -0400
Received: from www.tglx.de ([62.245.132.106]:35319 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0JOTSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:18:40 -0400
Date: Fri, 15 Oct 2010 21:18:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhart@linux.intel.com>
cc: Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        =?ISO-8859-15?Q?Matthieu_Fertr=E9?= <matthieu.fertre@kerlabs.com>
Subject: Re: [RESEND PATCH] futex: fix key reference counter in case of
 requeue.
In-Reply-To: <4CB8A7EB.6050303@linux.intel.com>
Message-ID: <alpine.LFD.2.00.1010152117340.2496@localhost6.localdomain6>
References: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com> <4CB8A7EB.6050303@linux.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-2076146326-1287170301=:2496"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-2076146326-1287170301=:2496
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 15 Oct 2010, Darren Hart wrote:
> On 10/14/2010 04:30 AM, Louis Rilling wrote:
> > Signed-off-by: Matthieu Fertré<matthieu.fertre@kerlabs.com>
> > Signed-off-by: Louis Rilling<louis.rilling@kerlabs.com>
> > ---
> >   kernel/futex.c |    8 ++++++--
> >   1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 6a3a5fa..bed6717 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -1791,6 +1791,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
> >   	struct restart_block *restart;
> >   	struct futex_hash_bucket *hb;
> >   	struct futex_q q;
> > +	union futex_key key;
> 
> We should be able to do this properly without requiring an additional key
> variable. I think tglx has proposed a suitable fix - but it needs testing to
> avoid any subtle regressions.

Well, that still needs a look into wait_requeue_pi() :)

Thanks,

	tglx
---1463795968-2076146326-1287170301=:2496--
