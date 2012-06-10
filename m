Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2FJUkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 16:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab2FJUkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 16:40:33 -0400
Date: Sun, 10 Jun 2012 16:40:16 -0400
From: Dave Jones <davej@redhat.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120610204015.GA10066@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Marc Dionne <marc.c.dionne@gmail.com>,
	Francois Romieu <romieu@fr.zoreil.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120606014656.GA24870@redhat.com>
 <20120606054251.GA24467@electric-eye.fr.zoreil.com>
 <20120608023420.GD7191@redhat.com>
 <alpine.LFD.2.02.1206080954440.3086@ionos>
 <20120608142333.GB1711@redhat.com>
 <alpine.LFD.2.02.1206081641040.3086@ionos>
 <20120608202701.GA26175@electric-eye.fr.zoreil.com>
 <alpine.LFD.2.02.1206082238120.3086@ionos>
 <20120608215328.GB26175@electric-eye.fr.zoreil.com>
 <CAB9dFdvXz85hc0p_Yanir4N6jJf9Q26crgU6a1r8VjWh8LXeHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB9dFdvXz85hc0p_Yanir4N6jJf9Q26crgU6a1r8VjWh8LXeHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 06:33:09PM -0400, Marc Dionne wrote:
 > On Fri, Jun 8, 2012 at 5:53 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
 > > index 4a05b68..d452441 100644
 > > --- a/drivers/net/ethernet/realtek/r8169.c
 > > +++ b/drivers/net/ethernet/realtek/r8169.c
 > > @@ -5934,11 +5934,7 @@ static void rtl_slow_event_work(struct rtl8169_private *tp)
 > >        if (status & LinkChg)
 > >                __rtl8169_check_link_status(dev, tp, tp->mmio_addr, true);
 > >
 > > -       napi_disable(&tp->napi);
 > > -       rtl_irq_disable(tp);
 > > -
 > > -       napi_enable(&tp->napi);
 > > -       napi_schedule(&tp->napi);
 > > +       rtl_irq_enable_all(tp);
 > >  }
 > >
 > >  static void rtl_task(struct work_struct *work)
 > 
 > That works for me - no warnings after several reboots and bringing the
 > interface up/down many times.

Yep, looks good to me too. Thanks Francois

	Dave

