Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab0DWUEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:04:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38672 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309Ab0DWUEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:04:32 -0400
Date: Fri, 23 Apr 2010 21:04:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       platform-driver-x86@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Brown, Len" <len.brown@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Make WMI be selected automatically when needed
Message-ID: <20100423200415.GA1009@srcf.ucam.org>
References: <4BC8FF9D.7050500@tremplin-utc.net> <20100416173127.6b968fd4.randy.dunlap@oracle.com> <4BC907B5.2050104@tremplin-utc.net> <20100423192059.GA32705@srcf.ucam.org> <4BD1FA5A.6060406@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BD1FA5A.6060406@tremplin-utc.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 09:51:54PM +0200, Éric Piel wrote:

> Currently there are 2 modules which select ACPI_WMI and 4 which depend
> on it. There are 7 modules which select BACKLIGHT_CLASS_DEVICE and as
> many which depend on it. Making usage of the select functionality all
> the time would avoid these inconsistencies.

Using select for ACPI_WMI is pretty clearly wrong since it fails in 
cases where ACPI isn't enabled. But I don't think the appropriate way to 
handle that is to encode the dependency between ACPI_WMI and ACPI 
multiple times - they should just be switched to depend on it instead.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
