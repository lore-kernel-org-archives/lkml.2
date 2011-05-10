Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1EJT56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:57:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36965 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab1EJT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:57:56 -0400
X-Sasl-enc: 7t3mlemxFzmYlepylWDqCoN8bEz7luhiABrzeYES5gSY 1305057475
Date: Tue, 10 May 2011 16:57:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Lutomirski <luto@mit.edu>, Anton Vorontsov <cbou@mail.ru>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [ibm-acpi-devel] [RFC] Controlling the ThinkPad battery charger
Message-ID: <20110510195753.GA5850@khazad-dum.debian.net>
References: <BANLkTinWna2sDDjbNC5xyGX3ELROs=Wd0w@mail.gmail.com>
 <20110509144546.GB13275@khazad-dum.debian.net>
 <BANLkTikB2TFF12vdwLqV9NRw4meEyDjvdA@mail.gmail.com>
 <20110509152941.GD13275@khazad-dum.debian.net>
 <20110510184302.GA15631@localhost.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510184302.GA15631@localhost.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, Pavel Machek wrote:
> Hmm, I jave a battery pack with reasonably good cells, but firmware killed
> it. IOW available for testing.

That is likely a problem with the battery pack uC, we cannot override that
using any know firmware path in the ThinkPad.

Does the thinkpad recognizes the presence of the battery pack?  If it
doesn't, the pack uC is probably dead or in safe mode, and you'd need to
hardware-hack it.

> (And who know, perhaps recalibrate command would bring it back to life?)

AFAIK, the recalibrate command really just does this:

1. sets 'force discharge' flag on EC so that it starts discharging the
   battery pack.  Discharging stops when cell voltage drops close to the
   minimum safety level.

2. sets stop threshold to 0 (100%) for that battery pack.

That way, the box will fully-drain the pack, and then charge it to full. At
that point, the recalibration is complete (the battery pack uC will
auto-calibrate itself when it notices it has hit the fully-drained and
fully-charged points).

You can monitor per-cell-group voltages through tp_smapi on a original IBM
battery pack, that functionality should still be around on the Lenovos.
Since this is not standard SBS functionality, it might not work on
non-original battery packs.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
