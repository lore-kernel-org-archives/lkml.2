Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2G2Tb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 15:31:57 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51312 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753365Ab2G2Tb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 15:31:56 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1/F0QonEZPFQRJyz2tpDrKAaHUyBUurMVxKtyjcMK
	pG2GhDsxkVqZbh
Message-ID: <50158FA9.7080700@gmx.net>
Date: Sun, 29 Jul 2012 21:31:53 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bhelgaas@google.com, lenb@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH V3 0/3] PNP: Allow PNP resources to be disabled (interface)
References: <50158321.4030007@gmx.net> <201207292122.28249.rjw@sisk.pl>
In-Reply-To: <201207292122.28249.rjw@sisk.pl>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/12 21:22, Rafael J. Wysocki wrote:

> Hi,
> 

[... long snip ...]

> 
> Do I understand correctly that you want to disable those things through
> sysfs?
> 
> Rafael
> 

Hi Rafael, 

the aim is to select a PNP ACPI option where resources can be disabled
(or are not needed).  E.g., the parallel port of the 600E can be used
with and without IRQ lines.  The means to allow for this is to use the
sysfs interface to select disabled resources (just like any other 
resource value).  In https://lkml.org/lkml/2011/7/3/41, I used the 
following example:

  echo disable > /sys/bus/pnp/devices/$device/resources
  echo clear > /sys/bus/pnp/devices/$device/resources
  echo set irq disabled > /sys/bus/pnp/devices/$device/resources
  echo fill > /sys/bus/pnp/devices/$device/resources
  echo activate > /sys/bus/pnp/devices/$device/resources

The third line is made possible by the patch series.  All other
lines are already implemented. 

--- Witold
