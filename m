Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab0HXILU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:11:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38341 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0HXILR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:11:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=vIR6u8Vf+y0B7kmyp1nmY1dRa9KsEkUVYH2vwRnfYglMocGBH8Rz+oRS8A6eRxpbCt
         UQ0raNqDiP3rPaFxONIW7aoM3FZQ0KBGr+PYvble93PTXoj63xCLV7Lv/7wxTYLCZiZJ
         0Qp/ZU4H1NiEeQUkt7Bf79+QKjcI1kIEAG5Eg=
Message-ID: <4C737E9F.7060107@gmail.com>
Date: Tue, 24 Aug 2010 10:11:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Robert Hancock <hancockrwd@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, lenb@kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/1] ACPI: pci_irq, add PRT_ quirk for IBM Bartolo
References: <1277673679-21458-1-git-send-email-jslaby@suse.cz>	<4C27E965.80508@gmail.com>	<4C283D84.6080504@suse.cz>	<20100628171410.GA27367@srcf.ucam.org>	<4C290245.2040001@suse.cz>	<20100628204820.GA32503@srcf.ucam.org>	<AANLkTil-sdbojCXBp6sR_4xL3JIe6ZENqXuueB61VJ8c@mail.gmail.com>	<4C2A3E27.4060407@suse.cz>	<AANLkTimkElR1u-iRyFfCEQR5VTZvcyEIGQodfmFNtbC_@mail.gmail.com>	<4C2B0C73.9050200@suse.cz>	<4C3278C8.60503@gmail.com>	<4C447D6D.5060801@suse.cz> <AANLkTin9_yEyMZImRbtKTvTeokks8dz0htQCu0B3RqXH@mail.gmail.com> <4C456C69.60606@suse.cz>
In-Reply-To: <4C456C69.60606@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/20/2010 11:29 AM, Jiri Slaby wrote:
> On 07/19/2010 09:19 PM, Robert Hancock wrote:
>> On Mon, Jul 19, 2010 at 10:29 AM, Jiri Slaby <jslaby@suse.cz> wrote:
>>>>> I still no point in comparing this to Windows' setup. We can't find out
>>>>> whether it is quirked or better (without some bug) handled there.
>>>>
>>>> Well, you can see if Windows shows IRQ 10 or 11 for that device..
>>>
>>> But how can I find out which link it is routed to in Windows? Without
>>> that information the number is meaningless, no?
>>
>> If you look at the pattern of which IRQs are shared by what devices in
>> Linux and compare it to Windows you can get a good idea. Normally the
>> assignment of devices to interrupt lines is hard-wired on the
>> motherboard and doesn't change.
> 
> Ok, thanks for the hint.
> 
> What we've found out is that it works on 2.6.27 (with slightly changed
> configuration).

No, this was a false alarm. It never worked with acpi irq routing on
older kernels in this HW configuration.

So, to sum up:
1) acpi routing enabled (no kernel parameter) => ports 4+5 defunct.
ports 4+5+6+7 are all on irq 11

2) acpi routing disabled (acpi=noirq) => all ports working, 4+5 on irq
10, 6+7 on irq 11

3) with the quirk [1] and acpi routing enabled => all ports working,
ports 4+5 on irq 10, 6+7 on irq 11

4) in windows => 4+5+6+7 are all on irq 9 and the ports are all working.

Any ideas what this means? Especially point 4)?

[1] http://lkml.org/lkml/2010/6/27/85

thanks,
-- 
js
