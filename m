Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab1FESxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:53:03 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34708 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab1FESxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:53:01 -0400
X-Sasl-enc: nPwSx3bzpoQ3Q9jJmlj3Up6C3PuXHKIw1kiIIrdHK9PJ 1307299979
Date: Sun, 5 Jun 2011 15:52:56 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Keith Packard <keithp@keithp.com>
Cc: ibm-acpi-devel@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: Some BIOS versions don't end in WW,
 remove check
Message-ID: <20110605185255.GA9549@khazad-dum.debian.net>
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
> EC version string is 6QHT28WW-1.09. The driver was requiring that both
> of these have 'WW' in positions 6 and 7. I don't know what the
> significance of having 'V1' there instead is, but removing the test
> makes the driver load on my machine.

Keith, thanks for the patch.  It has been shipped in mainline for a while
now.  That V1 postfix means the factory shipped a pre-release BIOS image for
some reason.  That's not a first with Lenovo and ThinkPads.

http://www-307.ibm.com/pc/support/site.wss/document.do?lndocid=MIGR-74983
(check the .txt file link):

VERSION INFORMATION
  The following versions of BIOS and ECP (Embedded Controller Program) have
  been released to date.

  Package        BIOS (BIOS ID)  ECP       (ECP ID)             Rev.  Issue
Date
  -------------- --------------- -----------------------------  ----
----------
  1.34           1.34 (6QET64WW) 1.13/1.13 (6QHT32WW/6SHT32WW)  01
2011/03/23
  1.32           1.32 (6QET62WW) 1.12/1.12 (6QHT31WW/6SHT31WW)  01
2011/01/13
  1.31           1.31 (6QET61WW) 1.12/1.12 (6QHT31WW/6SHT31WW)  01
2010/11/12
  1.22           1.22 (6QET52WW) 1.11/1.11 (6QHT30WW/6SHT30WW)  01
2010/09/09
  1.17           1.17 (6QET47WW) 1.10/1.10 (6QHT29WW/6SHT29WW)  01
2010/07/30
  1.16           1.16 (6QET46WW) 1.09/1.09 (6QHT28WW/6SHT28WW)  01
2010/06/29
  1.15-1.09/1.09 1.15 (6QET45WW) 1.09/1.09 (6QHT28WW/6SHT28WW)  01
2010/05/19
  1.14-1.09/1.09 1.14 (6QET44WW) 1.09/1.09 (6QHT28WW/6SHT28WW)  02
2010/05/07
  1.14-1.09/1.09 1.14 (6QET44WW) 1.09/1.09 (6QHT28WW/6SHT28WW)  01
2010/04/23
  1.12-1.07/1.07 1.12 (6QET42WW) 1.07/1.07 (6QHT26WW/6SHT26WW)  01
2010/04/05
  1.09-1.06/1.06 1.09 (6QET39WW) 1.06/1.06 (6QHT25WW/6SHT25WW)  01
2010/03/03
  1.05-1.03/1.03 1.05 (6QET35WW) 1.03/1.03 (6QHT22WW/6SHT22WW)  01
2010/02/16

Notice that all public releases have the WW suffix.

The changelog in that .txt file worries me.  You might really want to update
if you're still at 1.16/1.09.

Anyway, I will add an extra patch to the driver to keep accepting non-WW
firmware, but to alert the user that something is weird and to check for a
BIOS update.  Since that might well still trigger on your box, I thought I
should drop you a direct note.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
