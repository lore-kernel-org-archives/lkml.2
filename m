Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab0JFCLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:11:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:38900 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab0JFCK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:10:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,287,1283756400"; 
   d="scan'208";a="332664531"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg@redhat.com>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Date: Tue, 5 Oct 2010 19:09:19 -0700
Subject: RE: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
 time as methods
Thread-Topic: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
 time as methods
Thread-Index: Actk480LGqAOQNwkTxysB8CftbIFAwAF3Qyw
Message-ID: <4911F71203A09E4D9981D27F9D830858B4893958@orsmsx503.amr.corp.intel.com>
References: <1286216549-5438-1-git-send-email-mjg@redhat.com>
 <1286216549-5438-2-git-send-email-mjg@redhat.com>
 <201010060118.50875.rjw@sisk.pl>
In-Reply-To: <201010060118.50875.rjw@sisk.pl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>In fact, what we need to handle is the case in which a GPE is pointed to by
>a _PRW method somewhere and we presume that it's necessary to execute
>Notify() for it regardless of whether or not it has a method, right?

Is this the "windows compatibility" case where windows claims to implement a "implicit notify" if the GPE method does not exist for a GPE referenced by a _PRW?



>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Tuesday, October 05, 2010 4:19 PM
>To: Matthew Garrett
>Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
>pci@vger.kernel.org; Moore, Robert
>Subject: Re: [PATCH 1/5] ACPI: Allow handlers to be installed at the same
>time as methods
>
>On Monday, October 04, 2010, Matthew Garrett wrote:
>> There are circumstances under which it may be desirable for GPE handlers
>> to be installable without displacing the existing GPE method. Add support
>> for this via a boolean argument to acpi_install_gpe_handler, and fix up
>the
>> existing users to ensure that their behaviour doesn't change.
>
>Hmm.  I'm not sure this is the best way to do that.
>
>In fact, what we need to handle is the case in which a GPE is pointed to by
>a _PRW method somewhere and we presume that it's necessary to execute
>Notify() for it regardless of whether or not it has a method, right?
>
>So, this GPE will have ACPI_GPE_CAN_WAKE, so can we just put something like
>
>if (gpe_event_info->flags & ACPI_GPE_CAN_WAKE)
>         execute Notify()
>
>somewhere around the switch statement in acpi_ev_gpe_dispatch()?
>
>Or perhaps replace acpi_ev_asynch_enable_gpe() with something that will
>execute Notify() and then do what the original acpi_ev_asynch_enable_gpe()
>does?
>
>That should be easier to implement after the changes we've been discussing
>with
>Bob recently (basically, handle both GPE handlers and _Lxx/_Exx
>analogously).
>
>Rafael
