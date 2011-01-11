Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1AKHiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 02:38:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:33829 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab1AKHiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 02:38:18 -0500
Subject: Re: [PATCH -v3 1/4] pci, usb:  Make usb handoff func all take base
 remapping
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <greg@kroah.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D2BF9F3.5080709@kernel.org>
References: <4D2A1382.7010407@kernel.org> <4D2AC6BF.3010907@kernel.org>
	 <4D2BA8FE.9090204@kernel.org> <4D2BAA75.60001@kernel.org>
	 <20110111010714.GB32585@kroah.com>  <4D2BB048.2050509@kernel.org>
	 <1294723290.17779.349.camel@pasglop>  <4D2BF9F3.5080709@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 18:37:47 +1100
Message-ID: <1294731467.17779.352.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-10 at 22:34 -0800, Yinghai Lu wrote:
> 
> system_state does not work.
> it only have BOOTING and RUNNING ...
> RUNNING is set in init/main.c::init_post().
> so early_quirk and pci_quirk all with BOOTING stage...

Or we can make msleep() itself safe...

Ben.

>  slab_is_available() could be used, but looks alike abuse.
> 
> > 
> > We could even wrap it into a safe_delay() function or whatever (in
> fact
> > why not make msleep() itself safe ? It's not like it was timing
> critical
> > code :-)
> 
> like 
> void safe_udelay(unsigned long usecs)
> {
>         if (slab_is_available())
>                 udelay(usecs)
>         else
>                 early_udelay(usecs);
> }
> 
> or wonder if you are happy with
> 
> void __weak safe_udelay(unsigned long usecs)
> {
>         udelay(usecs);
> }
> 
> and will have x86 have it's own safe_udelay... 

