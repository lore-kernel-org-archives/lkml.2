Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1EQRsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:48:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50543 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab1EQRsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:48:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mENI6W8W2zmYFvZm2akkrR+oWIFoIWj0Mw1M7Z2D8IopwSvKOwg+DWDl7kkJJlpzw+
         iqWzOOHMOFPngpMTek2y3lWVMybVRDmLb6OXJZm9hdi1iMpD1Zf4guYCC0kIwm7vZuhR
         Vl+hv03D2NsOJGRQFD7XpnEpZkTv3/uiOHfFc=
MIME-Version: 1.0
In-Reply-To: <4DD2B178.3050907@broadcom.com>
References: <1304960206-8832-1-git-send-email-zajec5@gmail.com>
	<4DD2B178.3050907@broadcom.com>
Date: Tue, 17 May 2011 19:48:18 +0200
Message-ID: <BANLkTin7woaT5Uaxvh4x2jp-J10jnzSdmA@mail.gmail.com>
Subject: Re: [PATCH V7] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Greg KH <greg@kroah.com>,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        George Kashperko <george@znau.edu.ua>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andy Botting <andy@andybotting.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/17 Arend van Spriel <arend@broadcom.com>:
> On 05/09/2011 06:56 PM, Rafał Miłecki wrote:
>>
>> Broadcom has released cards based on a new AMBA-based bus type. From a
>> programming point of view, this new bus type differs from AMBA and does
>> not use AMBA common registers. It also differs enough from SSB. We
>> decided that a new bus driver is needed to keep the code clean.
>>
>> In its current form, the driver detects devices present on the bus and
>> registers them in the system. It allows registering BCMA drivers for
>> specified bus devices and provides them basic operations. The bus driver
>> itself includes two important bus managing drivers: ChipCommon core
>> driver and PCI(c) core driver. They are early used to allow correct
>> initialization.
>>
>> Currently code is limited to supporting buses on PCI(e) devices, however
>> the driver is designed to be used also on other hosts. The host
>> abstraction layer is implemented and already used for PCI(e).
>>
>> Support for PCI(e) hosts is working and seems to be stable (access to
>> 80211 core was tested successfully on a few devices). We can still
>> optimize it by using some fixed windows, but this can be done later
>> without affecting any external code. Windows are just ranges in MMIO
>> used for accessing cores on the bus.
>
> Hi Rafał,
>
> Just some minor feedback on coding style. I wanted to make a change in
> host_pci.c to avoid changing the PCI BAR window and noticed following:

Sorry?


> 1. indentation is all spaces.

You can find spaces only for aligning text in newline after breaking
more-than-80-chars lines.


> 2. initial indent is 7 spaces, and subsequent indents are 8 spaces.

$ grep "        " ./*c | wc -l
0


> 3. pointer assignment: ptr =&var;

$ grep "=&" ./*c | wc -l
0


> 4. output parameter: foo(bar,&yabar);

$ grep ",&" ./*c | wc -l
0

-- 
Rafał
