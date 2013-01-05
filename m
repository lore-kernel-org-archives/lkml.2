Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3AEAtB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 19:49:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60597 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab3AEAs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 19:48:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Jiang Liu <liuj97@gmail.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Sat, 05 Jan 2013 01:54:34 +0100
Message-ID: <7114758.9n3BYUUJrs@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo6y6TmoGA6FXSoV2TZ5ihvC6d-j_EWqvzL1m84dhBYoJQ@mail.gmail.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <CAE9FiQWzc+tYTnJx96po+dY-3k-Bbv_Sg943jvGJcbGPDLfMmA@mail.gmail.com> <CAErSpo6y6TmoGA6FXSoV2TZ5ihvC6d-j_EWqvzL1m84dhBYoJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 05:36:55 PM Bjorn Helgaas wrote:
> On Fri, Jan 4, 2013 at 5:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Jan 4, 2013 at 4:14 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Friday, January 04, 2013 04:03:01 PM Yinghai Lu wrote:
> >>> On Fri, Jan 4, 2013 at 3:38 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> >> --- a/arch/x86/include/asm/pci.h
> >>> >> +++ b/arch/x86/include/asm/pci.h
> >>> >> @@ -14,6 +14,7 @@
> >>> >>  struct pci_sysdata {
> >>> >>       int             domain;         /* PCI domain */
> >>> >>       int             node;           /* NUMA node */
> >>> >> +     void            *acpi_handle;
> >>> >>  #ifdef CONFIG_X86_64
> >>> >>       void            *iommu;         /* IOMMU private data */
> >>> >>  #endif
> >>> >>
> >>>
> >>> acpi_handle is not good name and it is confusing.
> >>
> >> Well, what would be a better name in your opinion?
> >>
> >> I was going to put that into a #ifdef CONFIG_ACPI / #endif, so what about
> >> calling it acpi_data?
> >
> > yes, with #ifdef, you can use acpi_handle type directly.
> >
> > it is acpi handle for pci_root.
> >
> > so would call int pci_root_acpi_handle ?
> 
> I just copied the name from the corresponding ia64 code.  I don't care
> if you want to change it, but I think there is *some* value in keeping
> the x86 and ia64 code as similar as possible because it would be nice
> to converge it some day.

Well, the corresponding data structure for ia64 is called struct pci_controller,
so it is quite obvious what acpi_handle in there means. :-)

Since the data structure for x86 is called struct pci_sysdata and the data
type for the field in question may be acpi_handle, perhaps we can call that
field simply "root_handle"?

Alternatively, in analogy with the iommu we could use void * as its data
type and call it simply "acpi".

That said I'm fine with using just "void *acpi_handle" as you did, but I would
do the #ifdef CONFIG_ACPI / #endif around it anyway.

I wonder what Peter thinks?

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
