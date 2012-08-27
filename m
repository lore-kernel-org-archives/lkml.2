Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab2H0UuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:50:22 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7455 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab2H0UuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:50:20 -0400
Message-ID: <1346100297.4732.115.camel@misato.fc.hp.com>
Subject: RE: [PATCH] hpwdt: Fix kdump issue in hpwdt
From: Toshi Kani <toshi.kani@hp.com>
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Lars Marowsky-Bree <lmb@suse.com>, "wim@iguana.be" <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Date: Mon, 27 Aug 2012 14:44:57 -0600
In-Reply-To: <9774516974AF5F4C8A2C3C69CD3412332335313E@G1W3651.americas.hpqcorp.net>
References: <1346093544-12007-1-git-send-email-toshi.kani@hp.com>
	 <20120827192227.GJ18709@suse.de>
	 <9774516974AF5F4C8A2C3C69CD3412332335313E@G1W3651.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-27 at 19:57 +0000, Mingarelli, Thomas wrote:
> The main issue here is when an NMI comes in (which is hpwdt's main
> focus...to source NMIs and then panic the box) and the system is
> configured for kdump. We want the kdump to succeed and if the iLO
> watchdog timer is left alone to keep running, the kdump will not
> succeed. It will be interrupted by an ASR. This change ensures that
> the iLO Watchdog timer is always stopped in the booting case (of any
> kernel) or when an NMI arrives and we are in the process of taking a
> kdump.

And this change does not prevent running the watchdog daemon on the
crash kernel, if we want to detect a hang condition on the crash kernel.
The timer is re-enabled when /dev/watchdog is opened.  The change only
assures the timer is enabled when the daemon starts up.  The timer
running on the crash kernel without starting the daemon is a problem as
it leads kdump to be interrupted. 

Thanks,
-Toshi


> 
> Tom
> 
> -----Original Message-----
> From: Lars Marowsky-Bree [mailto:lmb@suse.com] 
> Sent: Monday, August 27, 2012 2:22 PM
> To: Kani, Toshimitsu; wim@iguana.be; linux-watchdog@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Mingarelli, Thomas; stable@vger.kernel.org
> Subject: Re: [PATCH] hpwdt: Fix kdump issue in hpwdt
> 
> On 2012-08-27T12:52:24, Toshi Kani <toshi.kani@hp.com> wrote:
> 
> > kdump can be interrupted by watchdog timer when the timer is left
> > activated on the crash kernel. Changed the hpwdt driver to disable
> > watchdog timer at boot-time. This assures that watchdog timer is
> > disabled until /dev/watchdog is opened, and prevents watchdog timer
> > to be left running on the crash kernel.
> 
> How does this protect against the system hanging again in the crash
> kernel, or possibly hardware caches to flush more data to shared
> storage?
> 
> (I'm asking from the perspective of the hpwdt being used as a fencing
> mechanism in a cluster setting.)
> 
> Or is the argument that it's "very unlikely" that a system in such a
> state would not make it far enough into the crash kernel?
> 
> 
> Regards,
>     Lars
> 


