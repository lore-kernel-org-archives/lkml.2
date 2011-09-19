Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1ISQVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:21:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:11778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554Ab1ISQVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:21:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:from:
	date:x-google-sender-auth:message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Tvhd3oQr3F3BylYKrT+DXCrFG6zjteqe9pRRi19q9aij5Qqjz2fQjNJmkBK3C3EQI
	PDl9tjuneCQnhtqtZalpA==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1109170921490.15004-100000@netrider.rowland.org>
References: <1316211355-2888-1-git-send-email-vpalatin@chromium.org> <Pine.LNX.4.44L0.1109170921490.15004-100000@netrider.rowland.org>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Mon, 19 Sep 2011 12:20:45 -0400
X-Google-Sender-Auth: CLyMkGycz8WFriSvKjFM8S30iBw
Message-ID: <CAP_ceTzpN3QO8Xx3262Uowbfzf__BDC0P2g_t=UQ6VRCg184Jw@mail.gmail.com>
Subject: Re: [RFC] PM / Runtime: decrease verbosity in kernel log
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 09:23, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 16 Sep 2011, Vincent Palatin wrote:
>
>> When activating the PCI runtime PM on a laptop, my kernel log is filled with
>> messages such as the following ones and can be hardly read to find interesting
>> information:
>> ehci_hcd 0000:00:1d.7: PME# disabled
>> ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> ehci_hcd 0000:00:1d.7: setting latency timer to 64
>> ehci_hcd 0000:00:1d.7: PCI INT A disabled
>> ehci_hcd 0000:00:1d.7: PME# enabled
>> ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0x92205000-0x922053ff] (PCI address [0x92205000-0x922053ff])
>> ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10b)
>> ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
> ...
>
>> All those messages are triggered by the following cause, the laptop has a USB
>> 3G modem with USB autosuspend activated. The USB device will wake up about
>> every 30s to do some network related activities. Every time, the modem wakes
>> up this triggers the wake up of the attached EHCI/PCI USB host controller
>> which reconfigures its PCI interface, then everything go back to a suspended mode.
>>
>> Having the same 10 lines of log repeated is not really useful, but I probably
>> cannot totally remove them since there are somewhat useful for PCI hotplug
>> users and other PCI debugging.
>> So, my proposal is to create a new dev_printk macro : "dev_printk_norpm" which
>> outputs traces only when the device has not the runtime PM activated,
>> and guard those traces with it.
>> (cf the 2 patches in this thread as a PoC)
>
> Wouldn't it be easier just to change the existing messages to DEBUG
> level?  Or are they more important than that?

Yes, I can simply replace all those printk by dev_dbg traces. For my
use case, it's perfect.
My main concern was people using PCI hotplug, I think, then, their log
will remain mostly silent when inserting a card, I don't know if this
is acceptable or not.

-- 
Vincent Palatin
