Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0DFHsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 03:48:01 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:19463 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab0DFHrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 03:47:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u7zYyYuCe3OA7MFRJasBx8u3QgZkD85Kgff3QnFyBtqQbh6LEcsonMyPSF4F+cHYqr
         LhqL/XLk93Ht8Uo9Qt4/FqDADbTyaPKcf/P4OuM7PVmXPf1veLinql22SN2J+ibBasB4
         TKp+lTswGP1vWcyOWXS5slTzDMOtDFyYEVS2c=
MIME-Version: 1.0
In-Reply-To: <20100310211704.GA29201@srcf.ucam.org>
References: <201003062236.09801.rjw@sisk.pl>
	 <548cdfc21003100254t5c94aca5u5cf1e9eb29215325@mail.gmail.com>
	 <20100310205618.GA28628@srcf.ucam.org>
	 <201003102215.26232.rjw@sisk.pl>
	 <20100310211704.GA29201@srcf.ucam.org>
Date: Tue, 6 Apr 2010 09:47:50 +0200
Message-ID: <q2xb170af451004060047t7b661f63p903d4bd7452a1e45@mail.gmail.com>
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume) 
	outside the graphics driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pauli Nieminen <suokkos@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, Luca Tettamanti <kronos.it@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/10 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Wed, Mar 10, 2010 at 10:15:26PM +0100, Rafael J. Wysocki wrote:
>> On Wednesday 10 March 2010, Matthew Garrett wrote:
>> > As far as the ACPI video driver goes, acpi_get_physical_pci_device()
>> > will give you something to work with.
>>
>> Hmm.  Did you mean acpi_get_physical_device()?
>
> Ah, no, acpi_get_pci_dev.

So, AFAIU acpi_get_pci_dev will give me pointer to struct pci_dev of
video card, yes?

There is some path I could use then:

struct pci_dev {
    .....
    struct pci_driver *driver;	/* which driver has allocated this device */
    .....
}

struct pci_driver {
    .....
    struct device_driver	driver;
    .....
}

Finally, struct device_driver is defined in device.h. Should I add flag
bool is_kms
to this struct then?

AFAIK we can not do anything with struct driver_private *p... Or is
there unified struct for video card drivers? We could then add flag
is_kms to some struct pointed by struct driver_private *p.

-- 
Rafał
