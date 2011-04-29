Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab1D2IP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:15:59 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:33378 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab1D2IPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:15:55 -0400
Date: Fri, 29 Apr 2011 10:15:32 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: James Nuss <jamesnuss@nanometrics.ca>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>, Ricardo Martins <rasm@fe.up.pt>,
        linuxpps@ml.enneenne.com, linux-kernel@vger.kernel.org
Message-ID: <20110429081531.GL11227@gundam.enneenne.com>
Mail-Followup-To: James Nuss <jamesnuss@nanometrics.ca>,
	Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	Ricardo Martins <rasm@fe.up.pt>, linuxpps@ml.enneenne.com,
	linux-kernel@vger.kernel.org
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca> <20110428152222.0271163f@apollo.gnet> <BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 04:03:59PM -0400, James Nuss wrote:
> >> +
> >> +     if (!(res->flags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
> >> +             pr_err(PPS_IRQ_NAME ": given IRQ resource must be edge triggered");
> >> +             return -EINVAL;
> >> +     }
> >
> > I think it doesn't actually expect that both flags are set because it
> > always treats it as assert in the irq handler. What does your signal
> > look like?
> 
> The conditional logic is that one of either IRQF_TRIGGER_RISING or
> IRQF_TRIGGER_FALLING must be set. It doesn't make much sense to have
> neither set for PPS signals.
> My intention is that the driver is generic enough so you can register
> an IRQ resource with either IRQF_TRIGGER_RISING or
> IRQF_TRIGGER_FALLING and you will get and assert event for that edge.
> Clear events are not generated as you suggest but I believe this is
> OK.
> My signal is a simple low-to-high transition indicating the PPS. But I
> believe you could register a device using this driver referencing the
> other edge if required.

The driver is ok for me but if you say that your «intention is that
the driver is generic enough» you should consider adding CLEAR events
since some GPIOs controller can manager IRQs for both edges... ;)

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
