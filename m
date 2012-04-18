Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab2DRBWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:22:23 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50888 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2DRBWV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <201204172243.39525.rjw@sisk.pl>
References: <4F8790F6.5080408@intel.com>
	<4F8CD18A.5080903@intel.com>
	<CAC=cRTMk-NTvo+DJ2mAq6_ZeVLbeqiGx+ttZG6Hr_hQyyYkfLw@mail.gmail.com>
	<201204172243.39525.rjw@sisk.pl>
Date: Wed, 18 Apr 2012 09:22:20 +0800
Message-ID: <CAC=cRTOTZ5Y-urtKLAbuyu8y1ttpG74u3AE0J0_eLg8_8C0PHA@mail.gmail.com>
Subject: Re: [RFC PATCH] PCIe: Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Zhang Rui <rui.zhang@intel.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 4:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, April 17, 2012, huang ying wrote:
>> On Tue, Apr 17, 2012 at 10:12 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
>> > On 04/17/2012 01:07 AM, Rafael J. Wysocki wrote:
>> >
>> >> BTW, can you please explain to me what the #WAKE signal is and how it is
>> >> different from PME#?
>> >
>> > #WAKE signal is triggered by a pin connected to the root complex or other
>> > motherboard logic. PME# is triggered by PME message sent to the port.
>>
>> PME# is a PCI pin, while WAKE# is a PCI Express pin.  In PCI Express,
>> there is no PME#, PME is delivered between end point device and root
>> port or root complex event collector via PME message, and the PME
>> message will trigger IRQ on root port or root complex event collector.
>>  WAKE# is not used for PCI Express D1, D2 and D3hot, it is just used
>> by D3cold.  When remote wakeup detected by end point device, it will
>> assert WAKE# to notify power controller (implemented via ACPI on some
>> platform), then power controller will turn on power for main link,
>> after link goes back to L0, PME message will be sent to root port or
>> root complex event collector by end point device.
>
> OK
>
> So do I understand correctly that the WAKE# signal here is the one described
> in Section 5.3.3.2 Link Wakeup of PCI Express Base spec. 2.0?
>
> So what happens is that it triggers a GPE and that GPE has a _Lxx method
> associated with it, I suppose.  Is that correct?

Yes.

Best Regards,
Huang Ying
