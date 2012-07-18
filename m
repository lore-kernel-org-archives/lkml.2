Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2GRVqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:46:08 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:11210 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2GRVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:46:06 -0400
Message-ID: <1342647682.3010.38.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: Joe Perches <joe@perches.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com, liuj97@gmail.com,
        srivatsa.bhat@linux.vnet.ibm.com, prarit@redhat.com,
        imammedo@redhat.com, vijaymohan.pandarathil@hp.com
Date: Wed, 18 Jul 2012 15:41:22 -0600
In-Reply-To: <1342646502.2215.2.camel@joe2Laptop>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342646502.2215.2.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 14:21 -0700, Joe Perches wrote:
> On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> > This patch introduces acpi_pr_<level>(), where <level> is a message
> > level such as err/warn/info, to support improved logging messages
> > for ACPI, esp. in hotplug operations.  acpi_pr_<level>() appends
> > "ACPI" prefix and ACPI object path to the messages.  This improves
> > diagnostics in hotplug operations since it identifies an object that
> > caused an issue in a log file.
> > 
> > acpi_pr_<level>() takes acpi_handle as an argument, which is passed
> > to ACPI hotplug notify handlers from the ACPI CA.  Therefore, it is
> > always available unlike other kernel objects, such as device.
> 
> Hi Toshi.
> 
> I'd be tempted to instead make the calls more like
> other <subsystem>_<level> uses and rename these to
> acpi_<level> and change the existing acpi_info to
> another name.

Hi Joe,

I agree with you.  Unfortunately, the ACPI CA (ACPI FW interpreter)
already uses them for its internal-use as follows, so I needed to come
up with some other name...  Hence, acpi_pr_<level>.

/*
 * Error reporting. Callers module and line number are inserted by
AE_INFO,
 * the plist contains a set of parens to allow variable-length lists.
 * These macros are used for both the debug and non-debug versions of
the code.
 */
#define ACPI_INFO(plist)                acpi_info plist
#define ACPI_WARNING(plist)             acpi_warning plist
#define ACPI_EXCEPTION(plist)           acpi_exception plist
#define ACPI_ERROR(plist)               acpi_error plist
#define ACPI_DEBUG_OBJECT(obj,l,i)      acpi_ex_do_debug_object(obj,l,i)


> Other than that, seems fine to me.

Great!  Can I consider it as Ack? :)


Thanks,
-Toshi


> cheers, Joe
> 


