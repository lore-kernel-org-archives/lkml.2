Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab1F2VJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 17:09:55 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:59669 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754860Ab1F2VJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 17:09:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JwnYMnlAQ6PvC5txFzp0J1s4D87pAIPrtxpmkb7EV91SPoQIeBq2EhwKILzLZYrMlKaItr3uMDlAy2TTLIDZL5x0oQvkSKxHfLm4PLeuFxnlwUy+17c0c4zOiNFfsQCo;
Date: Wed, 29 Jun 2011 14:06:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: Re: Build regressions/improvements in v3.0-rc5 (arch/cris)
Message-Id: <20110629140619.744da8ea.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
References: <alpine.DEB.2.00.1106291011400.10665@ayla.of.borg>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 10:13:17 +0200 (CEST) Geert Uytterhoeven wrote:

> *** ERRORS ***
> 
> 698 regressions:

>   + net/mac80211/led.c: error: 'struct led_classdev' has no member named 'trig_list':  => 213, 277
>   + net/mac80211/led.c: error: dereferencing pointer to incomplete type:  => 73, 91, 100, 82
>   + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_register':  => 74
>   + net/mac80211/led.c: error: implicit declaration of function 'led_trigger_unregister':  => 118
>   + net/mac80211/led.c: error: invalid application of 'sizeof' to incomplete type 'struct led_trigger' :  => 98, 71, 89, 80


I think that this is what Andrew would call a cockup, or at least I would.

These errors shouldn't be possible since net/mac80211/Kconfig says:

config MAC80211_LEDS
	bool "Enable LED triggers"
	depends on MAC80211
	depends on LEDS_CLASS
	select LEDS_TRIGGERS



Preferably arch/cris/Kconfig would source drivers/Kconfig instead of sourcing
individual drivers/foobar/Kconfig.

Second option is for arch/cris/Kconfig to source drivers/leds/Kconfig
unless there is some reason to avoid this (?).

Or we should just prevent this particular driver from being built,
but that's the least desirable choice here.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
