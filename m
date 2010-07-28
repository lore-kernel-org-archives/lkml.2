Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0G1DkU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 23:40:20 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49081 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0G1DkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 23:40:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C4FA663.9090204@jp.fujitsu.com>
Date: Wed, 28 Jul 2010 12:39:15 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-pci@vger.kernel.org, Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native services
 simultaneously
References: <201007250105.23610.rjw@sisk.pl>
In-Reply-To: <201007250105.23610.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2010/07/25 8:05), Rafael J. Wysocki wrote:
> It turns out that asking ACPI BIOS, through _OSC, for control of each
> PCIe port native service individually sometimes confuses the BIOS if
> one sevice is requested while the others are not (eg. requesting
> control of the native PCIe PME without requesting control of the
> native PCIe hot-plug at the same time leads to interrupt storms on
> some systems).

Then why not invent quirks or something for such systems?

IMHO it sounds like a BIOS bug since it should grant PME control to
OS only when both of PME and pciehp (plus PCIe caps) are requested
at same time.

Did you confirm that the system also confuses when pciehp is requested
without requesting PME?
e.g. assume that some BIOS might behave:
  _OSC(pciehp)         =>  OK
  _OSC(PME)            =>  NG (bugs on shared interrupt?)
  _OSC(pciehp|PME)     =>  OK
  _OSC(SHPC)           =>  OK
  _OSC(pciehp|SHPC)    =>  NG (must choose one, not both)
  _OSC(AER|SHPC)       =>  OK

I don't doubt that handling of _OSC needs some improvement...


Thanks,
H.Seto


