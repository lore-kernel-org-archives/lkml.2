Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2K0NdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 08:33:23 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36127 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab2K0NdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:33:21 -0500
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: "=?iso-8859-1?Q?'Bruno_Pr=E9mont'?=" <bonbons@linux-vserver.org>,
        <support@supermicro.com>, <linux-kernel@vger.kernel.org>,
        "'Dan Williams'" <djbw@fb.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com> <20121126224245.248f0901@neptune.home> <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com> <CAErSpo6vrHMTht1nQxiF6HD7qCvUE-NS2eAnQjgUXym1pnNkSA@mail.gmail.com> <004201cdcc3a$a7538310$f5fa8930$@lucidpixels.com> <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com>
In-Reply-To: <CAErSpo7530xA6=1Ytj09dwyS1M_N_yAfk4xkr3f9Z_NBn6TJrA@mail.gmail.com>
Subject: RE: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware bug question
Date: Tue, 27 Nov 2012 08:33:16 -0500
Message-ID: <00a501cdcca3$c2638510$472a8f30$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH421ylXKr/7aSEd56ctRShmAJ9gwGHtGctAMAwLAsA1DUSgwLbZdCZAXol/xqXbAC00A==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Bjorn Helgaas [mailto:bhelgaas@google.com] 
Sent: Monday, November 26, 2012 8:12 PM
To: Justin Piszcz
Cc: Bruno Prémont; support@supermicro.com; linux-kernel@vger.kernel.org; Dan
Williams
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
bug question

On Mon, Nov 26, 2012 at 6:00 PM, Justin Piszcz <jpiszcz@lucidpixels.com>
wrote:
>
>
> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Monday, November 26, 2012 8:00 PM
> To: Bruno Prémont
> Cc: Justin Piszcz; support@supermicro.com; linux-kernel@vger.kernel.org;
Dan
> Williams
> Subject: Re: Supermicro X9SRL-F - channel enumeration error &
ACPI/firmware
> bug question
>
> [Try Dan's current email address; sorry Dan]
>
> On Mon, Nov 26, 2012 at 5:56 PM, Bjorn Helgaas <bhelgaas@google.com>
wrote:
>> [+cc Dan]
>>
>> On Mon, Nov 26, 2012 at 2:42 PM, Bruno Prémont
>> <bonbons@linux-vserver.org> wrote:
>>> Hi Justin,
>>>
>>> On Sat, 24 November 2012 "Justin Piszcz" wrote:
>>>> Is the following normal on an X9SRL-F board (bios 1.0a)?
>>>>
>>>> In the manual it states:
>>>>
>>>> Data Direct I/O
>>>> Select Enabled to enable Intel I/OAT (I/O Acceleration Technology),
> which
>>>> significantly reduces CPU overhead by leveraging CPU architectural
>>>> improvements and freeing the system resource for other tasks. The>
> Here is the full dmesg: (I went back to my older kernel, let me know if
you
> need a dmesg w/ those options enabled)
> http://home.comcast.net/~jpiszcz/20121126/dmesg.txt

It looks like maybe you don't have CONFIG_PCI_MMCONFIG turned on?

Hi,

I have two supermicro boards I am trying this on, I tried this on another
system I have (X8DTH-6F), with all of these options enabled, the system does
not boot.  It cannot talk to the SATA boot drive.

" 5520 chips built in, the X8DTH-6/X8DTH-6F/X8DTH-i/X8DTH-iF offers ......
The Intel I/OAT (I/O Acceleration Technology) significantly reduces CPU
over- head by ..."

When the following options are enabled, the system does not boot:

+CONFIG_HAVE_INTEL_TXT=y
+CONFIG_IOMMU_API=y
+CONFIG_IOMMU_SUPPORT=y
+CONFIG_DMAR_TABLE=y
+CONFIG_INTEL_IOMMU=y
+CONFIG_INTEL_IOMMU_DEFAULT_ON=y
+CONFIG_INTEL_IOMMU_FLOPPY_WA=y

It fails like so:

(Fails to talk to the SSD)
http://home.comcast.net/~jpiszcz/20121127/photo1-resize.jpg

(then, a few moments later: Kernel panic)
http://home.comcast.net/~jpiszcz/20121127/photo2-resize.jpg

With those options disabled, the system boots (and always has booted fine).
Is there a certain combination of parameters that allows I/OAT to be enabled
_and_ allow the system to boot?

Justin.




