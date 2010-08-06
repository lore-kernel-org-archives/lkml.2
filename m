Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934727Ab0HFMfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:35:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35588 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab0HFMfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:35:50 -0400
Date: Fri, 6 Aug 2010 13:35:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: david@lang.hm
Cc: Brian Swetland <swetland@google.com>, paulmck@linux.vnet.ibm.com,
        kevin granade <kevin.granade@gmail.com>,
        Arve Hj?nnev?g <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100806123515.GF31326@sirena.org.uk>
References: <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com> <alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm> <AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com> <20100805230304.GQ2447@linux.vnet.ibm.com> <AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com> <alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm> <AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com> <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm> <AANLkTimWqFkDWvGwVGWD94488gs+CXgpB9juwM5G11ud@mail.gmail.com> <alpine.DEB.2.00.1008060106260.30564@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008060106260.30564@asgard.lang.hm>
X-Cookie: No line available at 300 baud.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:07:47AM -0700, david@lang.hm wrote:

> on a given piece of hardware, does suspend always leave the same  
> peripherals on, or do you sometimes power more things down than other  
> times when suspending?

Different bits of hardware get powered down depending on current system
state.  In the audio case (which is so far as I know the only case for
this sort of stuff that currently does anything in mainline) we'll keep
alive any active paths (that is, paths carrying live audio) between
endpoints in the audio subsystem which have been explicitly marked as
staying alive during suspend.  Other audio paths will be powered down
when the system suspends.  During normal run time only paths that are
active will be powered up.
