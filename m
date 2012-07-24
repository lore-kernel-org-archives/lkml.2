Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030181Ab2GXSSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:18:30 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49580 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933707Ab2GXSSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:18:25 -0400
Date: Tue, 24 Jul 2012 19:18:20 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>
Subject: Re: [RFC][PATCH v2 2/3] Hold multiple logs
Message-ID: <20120724181820.GA23820@srcf.ucam.org>
References: <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com>
 <20120723141632.GB23047@srcf.ucam.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB33479@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F19370A1B@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19370A1B@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 05:52:25PM +0000, Luck, Tony wrote:
> 	if (QueryVariableInfo says enough space)
> 		pstore saves log as new record
> 	else
> 		we consider over-write options to re-use an existing record, or just drop this one

I'd lean towards saying drop, and rely on userspace to do something 
useful. Personal experience is that if two oopses are unrelated then 
there's enough time for userspace to do something and remove the 
existing record, and if they're related it's the first one that tells 
you where the problem actually is.

One thing that's worth noting - UEFI systems will typically only recover 
deleted space on reset. create->delete->create->delete will reduce 
available space until the platform is rebooted, at which point the 
deleted portion will become available again.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
