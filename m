Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab1KSPo3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 10:44:29 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36365 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555Ab1KSPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 10:44:27 -0500
X-Sasl-enc: BmZR/mIlYhlNIUiRh/PWAuywSue2MZ6jrGtLzO9VALY5 1321717466
Date: Sat, 19 Nov 2011 13:44:23 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?utf-8?B?5bCP6b6ZIOmZiA==?= <chillermillerlong@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: thinkpad_acpi does not generate correct ACPI events when
 brightness_enable=0
Message-ID: <20111119154423.GA11743@khazad-dum.debian.net>
References: <BAY156-W333AEB3C478890404DB815A3C50@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BAY156-W333AEB3C478890404DB815A3C50@phx.gbl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Nov 2011, 小龙 陈 wrote:
>   rmmod thinkpad_acpi  modprobe thinkpad_acpi brightness_enable=0
> The "acpi_listen" command shows this following when either the brightness up orbrightness down button is pressed:
>   ibm/hotkey LEN0068:00 00000080 00006050

This is an auxiliary event, only available in certain Lenovo boxes, and
thinkpad-acpi doesn't do much with it.

> and also the following when the brightness up button is pressed:
>   video/brightnessup BRTUP 00000086 00000000
> The following brightness down ACPI event is only generated after the module isreloaded:
>   video/brightnessdown BRTDN 00000087 00000000
> Is this a known bug (or even a bug at all)? The kernel bugzilla is down.

It is probably a bug, yes.  But where?  You're looking at acpi video output,
not thinkpad-acpi output.  The ACPI firmware clearly is changing its
behaviour when thinkpad-acpi is reloaded, which probably means it is broken
and it will have to be worked around if a BIOS update doesn't fix it.  That
wouldn't be surprising at all...

Are you using the latest BIOS/EC firmware for your thinkpad?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
