Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab0KYQOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:14:38 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50482 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab0KYQOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=TaCdZ+/yeN1rEnAjL584zonmNl0OuYCskSIUiSe9WD9DBDNDMbXZLbXD3YRwQqkvK3
         /lDooYOcrgaOaiUQLjF0+bTaCL+gFKQriF9hR5HLi6UD9xdmx2KRXDeP8ansKaOIDy7p
         02HiYLSYP9Fvob1wSfN+vR/C3g/MXhT4S11qk=
Message-ID: <4CEE8B67.2050701@gmail.com>
Date: Thu, 25 Nov 2010 21:14:31 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101029 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Nobody cared about IRQs at shutdown
References: <Pine.LNX.4.44L0.1011251056530.22247-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011251056530.22247-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.11.2010 21:06, Alan Stern wrote:
> On Thu, 25 Nov 2010, Alexander E. Patrakov wrote:
>
>> Hello.
>>
>> After switching my Gentoo desktop from sysvinit + openrc to systemd, I
>> started getting "nobody cared" messages about IRQs 16 and 19 (common
>> thing: they are assigned to the USB controllers, that's why CC:
> According to your listing, they are used by uhci-hcd.  Do the messages
> go away if you unload uhci-hcd before shutting down?

It is not a module here, so I have to recompile the kernel in order to 
try this. Will do that tomorrow.

> You may need to debug the uhci-hcd driver. Look into
> drivers/usb/host/uhci-hcd.c; the uhci_shutdown() routine ought to be
> called and it ought to call uhci_hc_died(), which in turn calls
> uhci_reset_hc() in pci-quirks.c, which is supposed to prevent the
> controller from generating any IRQs.

OK, tomorrow I will add some printks there.

> Do you have any USB devices attached to bus 3 or bus 6?

Yes:

Bus 006 Device 002: ID 05d8:4002 Ultima Electronics Corp. Artec Ultima 
2000 (GT6801 based)/Lifetec LT9385/ScanMagic 1200 UB Plus Scanner

Should I unplug it and retest the bug now?

-- 
Alexander E. Patrakov
