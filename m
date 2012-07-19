Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2GSOlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:41:20 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20940 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2GSOlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:41:16 -0400
Message-ID: <1342708592.3010.143.camel@misato.fc.hp.com>
Subject: RE: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: Joe Perches <joe@perches.com>, "Lin, Ming M" <ming.m.lin@intel.com>,
        "Tang, Feng" <feng.tang@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "vijaymohan.pandarathil@hp.com" <vijaymohan.pandarathil@hp.com>
Date: Thu, 19 Jul 2012 08:36:32 -0600
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346B2FD73@ORSMSX101.amr.corp.intel.com>
References: <1342644027-19559-1-git-send-email-toshi.kani@hp.com>
	 <1342644027-19559-2-git-send-email-toshi.kani@hp.com>
	 <1342646502.2215.2.camel@joe2Laptop>
	 <1342647682.3010.38.camel@misato.fc.hp.com>
	 <1342648452.2215.12.camel@joe2Laptop>
	 <1342649293.3010.49.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E346B2FD73@ORSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-19 at 05:35 +0000, Moore, Robert wrote:
> >> I wouldn't have a problem renaming a few of those to
> >> something like:
> >>
> >> #define ACPI_INFO(plist)	acpi_old_info plist
> >> #define ACPI_WARNING(plist)	acpi_old_warning plist
> >> #define ACPI_ERROR(plist)	acpi_old_error plist
> >>
> >> The acpi folk might though.
> >
> >Hi Joe,
> >
> >ACPI CA is being developed by Intel as OS-neutral code, and is used by
> >multiple OSes including Linux.  So, I am not sure how easy to make such
> >changes.  I am copying to Lin Ming.
> 
> 
> Please don't even consider doing something like this. As we continue to
> develop and maintain the ACPICA code, these kinds of OS-specific divergences
> from the base ACPICA code cause us all kinds of grief, including the accidental
> creation of new bugs as it becomes more and more difficult to integrate the base
> ACPICA code back into Linux.

Hi Bob,

Thanks for the clarification!  I agree with you.

> In fact, we have a major project this year (and probably far into next year) to
> continue to minimize (i.e., fix) this type of Linux/ACPICA divergence -- of which
> many have crept in over the years that ACPICA has been present in the Linux kernel.

Cool!  I think that's very good improvement.

Thanks again,
-Toshi


> Bob
> 
>
> >-----Original Message-----
> >From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> >owner@vger.kernel.org] On Behalf Of Toshi Kani
> >Sent: Wednesday, July 18, 2012 3:08 PM
> >To: Joe Perches; Lin, Ming M
> >Cc: lenb@kernel.org; linux-acpi@vger.kernel.org; linux-
> >kernel@vger.kernel.org; bhelgaas@google.com;
> >isimatu.yasuaki@jp.fujitsu.com; liuj97@gmail.com;
> >srivatsa.bhat@linux.vnet.ibm.com; prarit@redhat.com; imammedo@redhat.com;
> >vijaymohan.pandarathil@hp.com
> >Subject: Re: [PATCH 1/4] ACPI: Add acpi_pr_<level>() interfaces
> >
> >On Wed, 2012-07-18 at 14:54 -0700, Joe Perches wrote:
> >> On Wed, 2012-07-18 at 15:41 -0600, Toshi Kani wrote:
> >> > On Wed, 2012-07-18 at 14:21 -0700, Joe Perches wrote:
> >> > > On Wed, 2012-07-18 at 14:40 -0600, Toshi Kani wrote:
> >> > > > This patch introduces acpi_pr_<level>(), where <level> is a message
> >> > > > level such as err/warn/info, to support improved logging messages
> >> > > > for ACPI, esp. in hotplug operations.  acpi_pr_<level>() appends
> >> > > > "ACPI" prefix and ACPI object path to the messages.  This improves
> >> > > > diagnostics in hotplug operations since it identifies an object
> >that
> >> > > > caused an issue in a log file.
> >> []
> >> > > I'd be tempted to instead make the calls more like
> >> > > other <subsystem>_<level> uses and rename these to
> >> > > acpi_<level> and change the existing acpi_info to
> >> > > another name.
> >> []
> >> > I agree with you.  Unfortunately, the ACPI CA (ACPI FW interpreter)
> >> > already uses them for its internal-use as follows, so I needed to come
> >> > up with some other name...  Hence, acpi_pr_<level>.
> >> >
> >> > /*
> >> >  * Error reporting. Callers module and line number are inserted by
> >AE_INFO,
> >> >  * the plist contains a set of parens to allow variable-length lists.
> >> >  * These macros are used for both the debug and non-debug versions of
> >the code.
> >> >  */
> >> > #define ACPI_INFO(plist)                acpi_info plist
> >> > #define ACPI_WARNING(plist)             acpi_warning plist
> >> > #define ACPI_EXCEPTION(plist)           acpi_exception plist
> >> > #define ACPI_ERROR(plist)               acpi_error plist
> >> > #define ACPI_DEBUG_OBJECT(obj,l,i)
> >acpi_ex_do_debug_object(obj,l,i)
> >>
> >> I wouldn't have a problem renaming a few of those to
> >> something like:
> >>
> >> #define ACPI_INFO(plist)	acpi_old_info plist
> >> #define ACPI_WARNING(plist)	acpi_old_warning plist
> >> #define ACPI_ERROR(plist)	acpi_old_error plist
> >>
> >> The acpi folk might though.
> >
> >Hi Joe,
> >
> >ACPI CA is being developed by Intel as OS-neutral code, and is used by
> >multiple OSes including Linux.  So, I am not sure how easy to make such
> >changes.  I am copying to Lin Ming.
> >
> >
> >> > > Other than that, seems fine to me.
> >> > Great!  Can I consider it as Ack? :)
> >>
> >> Fix the kfree first.
> >
> >Please see my other email.  Do you think the check should be added
> >despite of the warning message?
> >
> >
> >> I rarely ack stuff as other people generally have to
> >> pick up the changes and I think acks are overrated.
> >
> >That's fair enough.
> >
> >Thanks!
> >-Toshi
> >
> >
> >> cheers, Joe
> >>
> >
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html


