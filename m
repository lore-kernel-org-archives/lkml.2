Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173Ab1D3AYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:24:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:42647 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498Ab1D3AX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:23:59 -0400
Date: Sat, 30 Apr 2011 02:23:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        john.stultz@linaro.org, arnd@arndb.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
In-Reply-To: <BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1104300220040.3005@ionos>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org> <BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-273686637-1304123035=:3005"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-273686637-1304123035=:3005
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 29 Apr 2011, Arve Hjønnevåg wrote:
> On Fri, Apr 29, 2011 at 10:31 AM, tip-bot for John Stultz
> <john.stultz@linaro.org> wrote:
> > -       set_normalized_timespec(&time,
> > -                               newtime + delta.tv_sec,
> > -                               (NSEC_PER_SEC >> 1) + delta.tv_nsec);
> > -       do_settimeofday(&time);
> > +       /* subtract kernel time between rtc_suspend to rtc_resume */
> > +       time = timespec_sub(time, timespec_sub(newts, oldts));
> 
> The delta you got from the rtc can be almost a second to long or
> short. Do you do anything to prevent these errors from accumulating?

By using the the magic crystal ball to avoid it or what do you have in
mind ?

Thanks,

	tglx
--8323328-273686637-1304123035=:3005--
