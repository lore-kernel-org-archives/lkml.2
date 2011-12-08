Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab1LHHlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:41:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:47163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab1LHHlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:41:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84201406"
Subject: Re: ACPI "_PDC" - acpi_processor_set_pdc()- execution regression -
 Linux-3.x
From: Lin Ming <ming.m.lin@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "wallak@free.fr" <wallak@free.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <CAErSpo7Dcxn7tsecDUXe6AQeRAchsU9tQjL7=-WPpPmDj2OUfw@mail.gmail.com>
References: <1323297487.4edfeacfc49ff@imp.free.fr>
	 <CAErSpo7Dcxn7tsecDUXe6AQeRAchsU9tQjL7=-WPpPmDj2OUfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Dec 2011 15:40:57 +0800
Message-ID: <1323330057.27764.14.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 13:01 +0800, Bjorn Helgaas wrote:
> [+cc linux-acpi and Lin Ming]
> 
> On Wed, Dec 7, 2011 at 3:38 PM,  <wallak@free.fr> wrote:
> > We have a regression on the ACPI stack of the last linux kernel line 3.x (3.1.4,
> > 3.2-rc4...). The ACPI "_PDC" chunk is not executed on some computers (e.g. Dell
> > X300; the function acpi_processor_set_pdc() is not called). This issue yield to
> > an uninitialized state of some ACPI variables.
> >
> > A patch is available below. This patch come back to the previous linux behavior,
> > and works fine.

Hi, Wallak

Please attach the acpidump output and kernel .config file.
And also the output of "cat /proc/cpuinfo"

(You can send these files to me offline in case they are too big for
mail list)

Thanks,
Lin Ming

> >
> > Best Regards,
> > Wallak.
> >
> > --- linux-3.1.4-mdf/drivers/acpi/processor_core.c.orig  2011-12-07
> > 23:12:57.000000000 +0100
> > +++ linux-3.1.4-mdf/drivers/acpi/processor_core.c       2011-12-07
> > 23:13:39.000000000 +0100
> > @@ -223,8 +223,8 @@
> >        type = (acpi_type == ACPI_TYPE_DEVICE) ? 1 : 0;
> >        cpuid = acpi_get_cpuid(handle, type, acpi_id);
> >
> > -       if (cpuid == -1)
> > -               return false;
> > +       if ((cpuid == -1) && (num_possible_cpus() > 1))
> > +               return false;
> >
> >        return true;
> >  }
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


