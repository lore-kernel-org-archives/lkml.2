Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0GAQ2C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:28:02 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36319 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755748Ab0GAQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:27:59 -0400
X-Sasl-enc: eY4GHwVEkCCqfW5a9uDXiihkeRHFmHo8TWGcSLmnudSE 1278001664
Date: Thu, 1 Jul 2010 13:27:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH 5/6] X86 platform drivers: Remove EC dump from
 thinkpad_acpi
Message-ID: <20100701162741.GC4789@khazad-dum.debian.net>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
 <1277996570-2686-6-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277996570-2686-6-git-send-email-trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010, Thomas Renninger wrote:
> There is a general interface for that now (provided by
> other patches in this patch series):
> /sys/devices/system/ec/*/io
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> CC: Alexey Starikovskiy <astarikovskiy@suse.de>
> CC: Len Brown <lenb@kernel.org>
> CC: linux-kernel@vger.kernel.org
> CC: linux-acpi@vger.kernel.org
> CC: platform-driver-x86@vger.kernel.org
> CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> CC: ibm-acpi-devel@lists.sourceforge.net

No outright objections, but...

> -EXPERIMENTAL: Embedded controller register dump -- /proc/acpi/ibm/ecdump
> -------------------------------------------------------------------------

[...]

> -registers. Values which have changed since the last time the registers
> -were dumped are marked with a star:

[...]

> -This feature can be used to determine the register holding the fan
> -speed on some models. To do that, do the following:
> -
> -	- make sure the battery is fully charged
> -	- make sure the fan is running
> -	- run 'cat /proc/acpi/ibm/ecdump' several times, once per second or so
> -
> -The first step makes sure various charging-related values don't
> -vary. The second ensures that the fan-related values do vary, since
> -the fan speed fluctuates a bit. The third will (hopefully) mark the
> -fan register with a star:
> -
> -[root@x40 ibm-acpi]# cat /proc/acpi/ibm/ecdump
> -EC       +00 +01 +02 +03 +04 +05 +06 +07 +08 +09 +0a +0b +0c +0d +0e +0f
> -EC 0x00:  a7  47  87  01  fe  96  00  08  01  00  cb  00  00  00  40  00
> -EC 0x10:  00  00  ff  ff  f4  3c  87  09  01  ff  42  01  ff  ff  0d  00
> -EC 0x20:  00  00  00  00  00  00  00  00  00  00  00  03  43  00  00  80
> -EC 0x30:  01  07  1a  00  30  04  00  00  85  00  00  10  00  50  00  00
> -EC 0x40:  00  00  00  00  00  00  14  01  00  04  00  00  00  00  00  00
> -EC 0x50:  00  c0  02  0d  00  01  01  02  02  03  03  03  03  bc  02  bc
> -EC 0x60:  02  bc  02  00  00  00  00  00  00  00  00  00  00  00  00  00
> -EC 0x70:  00  00  00  00  00  12  30  40  24  27  2c  27  21  80  1f  80
> -EC 0x80:  00  00  00  06 *be  0d  03  00  00  00  0e  07  00  00  00  00
> -EC 0x90:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
> -EC 0xa0:  ff  09  ff  09  ff  ff  64  00  00  00  a2  41  ff  ff  e0  00
> -EC 0xb0:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
> -EC 0xc0:  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
> -EC 0xd0:  03  00  00  00  00  00  00  00  00  00  00  00  00  00  00  00
> -EC 0xe0:  00  00  00  00  00  00  00  00  11  20  49  04  24  06  55  03
> -EC 0xf0:  31  55  48  54  35  38  57  57  08  2f  45  73  07  65  6c  1a
> -
> -Another set of values that varies often is the temperature
> -readings. Since temperatures don't change vary fast, you can take
> -several quick dumps to eliminate them.
> -
> -You can use a similar method to figure out the meaning of other
> -embedded controller registers - e.g. make sure nothing else changes
> -except the charging or discharging battery to determine which
> -registers contain the current battery capacity, etc. If you experiment
> -with this, do send me your results (including some complete dumps with
> -a description of the conditions when they were taken.)

I'd prefer if the above text gets replaced by something that adds a pointer
to the new facility, instead of being just outright removed.  Also, the text
about how to use the facility to detect tachometers and thermometers should
be retained, if at all possible.

Soes your helper userspace util do the "differential" analysis that
thinkpad-acpi used to (the "*" after values that changed since last read)?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
