Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab0JDQYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 12:24:36 -0400
Received: from smtp.witbe.net ([81.88.96.48]:41044 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab0JDQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:24:35 -0400
X-Greylist: delayed 1269 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Oct 2010 12:24:35 EDT
Date: Mon, 4 Oct 2010 17:55:06 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: Jiri Slaby <jslaby@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, clemens@ladisch.de, venki@google.com,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>, rol@witbe.net
Subject: Re: HPET causes tasks to freeze (still in 2.6.36-rc6)
Message-ID: <20101004175506.3e6b8c2b@tux.DEF.witbe.net>
In-Reply-To: <4CA9F471.2080704@suse.cz>
References: <4CA9F471.2080704@suse.cz>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 04 Oct 2010 17:36:17 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> HPET as a clocksource has still issues in the latest kernels (confirmed
> in 2.6.36-rc6) at least on x86_64. Unless clocksource=jiffies,
> clocksource=tsc or nolapic_timer is used, the system is unusable. Tasks
> are not woken unless mouse is moved, key is pressed (or other hard irq
> triggered). 2.6.32 seems to be the last working.
> 
> The bug was originally reported in the bugzilla here:
> https://bugzilla.novell.com/show_bug.cgi?id=579932
> 
> To quote:
> "My clock is seriously lagging behind. After having used hpet for 10.5
> hours now, the clock is 5.5 hours too late!"
> 
> dmesg is attached. Any ideas what's still wrong with HPET?

I've been experiencing that also with some Supermicro servers...

and last week, I switched to 2.6.35.5, which is now no more exhibiting this
weird behavior, but it may be because the machine has elected tsc as its
clocksource.

I must also say that kernels before 2.6.35.5 (namely 2.6.28.9) were showing
this strange behavior whatever clocksource I was using, so it was not
specifically HPET-related, but the "Tasks are not woken unless mouse is moved,
key is pressed (or other hard irq triggered)" part was exactly what i was 
experiencing.

Paul
