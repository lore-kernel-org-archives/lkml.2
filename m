Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1CNPqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:46:55 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40302 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752154Ab1CNPqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:46:54 -0400
X-Sasl-enc: uqtGq3ribi9379xCL/NviTXncwjdN7eCLDbtvK6ZhNeW 1300117612
Date: Mon, 14 Mar 2011 12:46:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Keith Packard <keithp@keithp.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: Some BIOS versions don't end in WW,
 remove check
Message-ID: <20110314154642.GA7474@khazad-dum.debian.net>
References: <1300085555-31022-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300085555-31022-1-git-send-email-keithp@keithp.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Mar 2011, Keith Packard wrote:
> My X201s BIOS version string is 6QET46V1 (1.16 ). The

This is not marked as a production release.

> EC version string is 6QHT28WW-1.09. The driver was requiring that both
> of these have 'WW' in positions 6 and 7. I don't know what the
> significance of having 'V1' there instead is, but removing the test
> makes the driver load on my machine.

I also don't know what V1 is, but Lenovo has shipped ThinkPads with firmware
that was not supposed to get shipped to the production lines at least
once...

On this case, it looks like someone forgot to give the 6QET46 the "WW" stamp
of aproval, or they shipped the image to the factory from the wrong point in
the QA pipeline.

Here:
http://www-307.ibm.com/pc/support/site.wss/document.do?lndocid=MIGR-74983

You will find the "summarized" changelogs of the firmware for the X201 (and
it looks like it is a good idea to upgrade based on those alone).  Near the
end of the page, there is a complete list of released firmware:

release  BIOS (BIOS ID) ECP (ECP ID)
	
1.32 	1.32 (6QET62WW)	1.12/1.12 (6QHT31WW / 6SHT31WW)
1.31 	1.31 (6QET61WW)	1.12/1.12 (6QHT31WW / 6SHT31WW)
1.22 	1.22 (6QET52WW)	1.11/1.11 (6QHT30WW / 6SHT30WW)
1.17 	1.17 (6QET47WW)	1.10/1.10 (6QHT29WW / 6SHT29WW)
1.16 	1.16 (6QET46WW)	1.09/1.09 (6QHT28WW / 6SHT28WW)
1.15 	1.15 (6QET45WW)	1.09/1.09 (6QHT28WW / 6SHT28WW)
1.14 	1.14 (6QET44WW)	1.09/1.09 (6QHT27WW / 6SHT27WW)
1.12 	1.12 (6QET42WW)	1.07/1.07 (6QHT26WW / 6SHT26WW)

It is interesting to notice that there is a single BIOS (6Q), but two
different EC firmware (6Q and 6S), make sure to use the correct one if you
try the update.

I am unsure of what would be the best course of action.  What you have is a
BIOS bug, probably with a released fix.  OTOH, the reason why I am so strict
on that string matching is that I don't want to match on strings if the game
changed under the driver, but that WW _really_ doesn't matter at all for the
driver (or the thinkpad) itself.

Maybe the driver should accept non-WW firmware, but warn the user to check
for firmware updates?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
