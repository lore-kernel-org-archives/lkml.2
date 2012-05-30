Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2E3OSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:18:49 -0400
Received: from [15.201.24.17] ([15.201.24.17]:14808 "EHLO
	g4t0014.houston.hp.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754883Ab2E3OSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:18:47 -0400
Message-ID: <1338387106.16730.456.camel@misato.fc.hp.com>
Subject: RE: [PATCH v4 0/6] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 May 2012 08:11:46 -0600
In-Reply-To: <94F2FBAB4432B54E8AACC7DFDE6C92E346ACC6F9@ORSMSX101.amr.corp.intel.com>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337880880.2718.68.camel@lorien2>
	 <1337888931.16730.393.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E346ACC639@ORSMSX101.amr.corp.intel.com>
	 <1338331496.2722.18.camel@lorien2>
	 <1338334995.16730.455.camel@misato.fc.hp.com>
	 <94F2FBAB4432B54E8AACC7DFDE6C92E346ACC6F9@ORSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 02:56 +0000, Moore, Robert wrote:
> It does not make any difference. Essentially, a get_handle is performed by evaluate_object anyway.
> 

Thanks Robert for the confirmation!
-Toshi


> >-----Original Message-----
> >From: Toshi Kani [mailto:toshi.kani@hp.com]
> >Sent: Tuesday, May 29, 2012 4:43 PM
> >To: shuahkhan@gmail.com
> >Cc: Moore, Robert; lenb@kernel.org; linux-acpi@vger.kernel.org;
> >bhelgaas@google.com; liuj97@gmail.com; andi@firstfloor.org; linux-
> >kernel@vger.kernel.org
> >Subject: RE: [PATCH v4 0/6] ACPI: Add _OST support for ACPI hotplug
> >
> >On Tue, 2012-05-29 at 16:44 -0600, Shuah Khan wrote:
> >> On Tue, 2012-05-29 at 22:27 +0000, Moore, Robert wrote:
> >> > > > 2. Calling acpi_get_handle() on _OST prior to executing the method.
> >> > > > This will ensure that this method only gets run if it is present
> >> > > under
> >> > > > the device in question. Coupled with what is already outlined in #1
> >> > > > above, now _OST gets executed only when it is defined under the
> >> > > device object.
> >> > > > Example case in the existing code, please see
> >> > > acpi_processor_ppc_ost()
> >> > > > implementation.
> >> > >
> >> > > Yes, I did look at acpi_processor_ppc_ost() when I implemented the
> >> > > function.  I believe calling acpi_get_handle() is redundant since
> >> > > acpi_ns_get_node() is called within acpi_evaluate_object() as well.
> >> > > acpi_evaluate_object() simply returns with AE_NOT_FOUND when _OST
> >> > > method does not exist.
> >> > >
> >> >
> >> > This is correct. If _OST does not exist, AE_NOT_FOUND will be returned
> >from evaluate_object.
> >>
> >> Yes that is correct from the ACPI Spec and implementation point of view.
> >> My thinking is that a call to acpi_get_handle() might not penalize the
> >> OS as much as acpi_evaluate_object() would on systems that don't
> >> actually implement _OST. In other words, acpi_get_handle() might not go
> >> as deep as acpi_evaluate_object() would go into the ACPI layer, hence
> >> might be a safer measure on platforms that don't actually implement this
> >> optional method under all devices included in this patch set.
> >>
> >
> >I do not think we need to worry about it.  The code difference is not
> >that much, and this _OST path is limited to ACPI hotplug operations,
> >which are infrequent events.  Automatic workload balancing can make
> >frequent use of the operations, but is not frequent enough to make any
> >difference here.  I think simpler code works fine.
> >
> >Thanks,
> >-Toshi
> 


