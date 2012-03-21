Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab2CUEsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:48:24 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:33053
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889Ab2CUEsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:48:20 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zcb8kz1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M17XCC-01-5FE-02
X-M-MSG: 
Date: Wed, 21 Mar 2012 12:48:06 +0800
From: Aaron Lu <aaron.lu@amd.com>
To: Lin Ming <ming.m.lin@intel.com>
CC: Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 5/8] libata-acpi: add ata port runtime D3Cold
 support
Message-ID: <20120321044806.GA6910@localhost.amd.com>
References: <1330592577-16546-1-git-send-email-ming.m.lin@intel.com>
 <1330592577-16546-6-git-send-email-ming.m.lin@intel.com>
 <20120319033616.GA32695@localhost.amd.com>
 <1332134820.17875.17.camel@minggr>
 <20120319063544.GA2707@localhost.amd.com>
 <1332140620.17875.35.camel@minggr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1332140620.17875.35.camel@minggr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 21 Mar 2012 04:48:06.0977 (UTC) FILETIME=[CEDEDB10:01CD071D]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:03:40PM +0800, Lin Ming wrote:
> > 
> > Sorry I didn't make it clear.
> > The problem here is, we are going to set the device power state to D3
> > cold, and current OSPM has no support for it.
> > 
> > Another patch of yours solved this problem by defining:
> > 1 Device supports D3 cold if it has _PR3;
> > 2 For a device to be put to D3 cold, power off all the power resources
> > referenced in its _PR3.
> > 
> > Since this can't work for AMD's platform(there is no _PR3 for the sata
> > acpi device), I would like to change this a little bit:
> > 1 Device supports D3 cold if it has _PR3 or _PS3;
> 
> _PS3 may only mean D3Hot support for other device.
> 
> You mentioned that AMD platform defined a special device, named ODDZ.
> 
> How about device supports D3 cold if
> 
> _PR3 or (is ODDZ and ODDZ._PS3)?

Sounds good, I'll do this, thanks.

> 
> > 2 For a device to be put to D3 cold, execute _PS3 first if available and
> > then deal with _PR3 as above.
> 
> __acpi_bus_set_power(...) has done this.
> 

Actually not, current implementation of __acpi_bus_set_power will call
_PS4 ;-)
I'll need to think of a way to handle the D3 cold case.

-Aaron


