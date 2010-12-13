Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0LMKCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:02:53 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:35574 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0LMKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:02:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=oK7GZztNWfWugp1a9d17AV8Ds8NyLyHXYltCp7b+ZNWwELYUZFop/0OmfHM6IB9dJR
         ey7e+5t52GwGgmD2AOQ5aReYXhWTzjbBtIeN+PXklz1SNC4mNvwxb3gXuBU+imkpRHmH
         MepmRRE79Kd/iTajLRXfi5QJIcf8aPDkCPXgE=
Message-ID: <4D05EF46.6010306@gmail.com>
Date: Mon, 13 Dec 2010 11:02:46 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        abelay@mit.edu, Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: resource map sanity check conflict
References: <4CED14C1.4050703@suse.cz> <4CFD44DD.3070901@gmail.com> <201012061334.57246.bjorn.helgaas@hp.com> <201012081256.06513.bjorn.helgaas@hp.com>
In-Reply-To: <201012081256.06513.bjorn.helgaas@hp.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 08:56 PM, Bjorn Helgaas wrote:
> On Monday, December 06, 2010 01:34:56 pm Bjorn Helgaas wrote:
>> On Monday, December 06, 2010 01:17:33 pm Jiri Slaby wrote:
>>> On 11/24/2010 08:22 PM, Bjorn Helgaas wrote:
>>>> On Wednesday, November 24, 2010 06:36:01 am Jiri Slaby wrote:
> ...
>>>>> pnp 00:0a: [mem 0xfed40000-0xfed44fff]
>>>>> pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
>>>>> ...
>>>>> resource map sanity check conflict: 0xfed40000 0xfed44fff 0xfed44000
> ...
>>>> Yes, this is related to the PCI resource changes I made recently.
>>>> We used to allocate PCI resources from low addresses first and work
>>>> upwards, and now we do the reverse.  So in 2.6.36, the "Intel Flush
>>>> Page" was probably allocated low in the [mem 0x7e000000-0xfebfffff]
>>>> window, but now we put it in the [mem 0xfed40000-0xfed4bfff] window:
>>>>
>>>>   pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
>>>>   pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
>>>>
>>>> I think the problem is that we ignore most of what ACPI tells us
>>>> about motherboard device resource usage.  We do have the "system"
>>>> driver, which reserves resources used by PNP0c01 and PNP0c02 devices,
>>>> but we don't do anything about other devices like the ATM1200/PNP0c31
>>>> device which, in your case, is using some of the space in that
>>>> [mem 0xfed40000-0xfed4bfff] host bridge window.
> 
>>> I created the bko entry some time ago:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=23802
> 
> I have a patch here for testing:
> 
>   https://bugzilla.kernel.org/attachment.cgi?id=39262

Yes, it works:
https://bugzillafiles.novell.org/attachment.cgi?id=404327

thanks,
-- 
js
