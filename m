Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1IUSWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:22:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48594 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab1IUSWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:22:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAP_ceTyXLO=mv1Ott=g3mG0y+Q+VUM3N8CA-Fqa-_=uj7LTbmw@mail.gmail.com>
References: <1316211355-2888-1-git-send-email-vpalatin@chromium.org>
	<Pine.LNX.4.44L0.1109170921490.15004-100000@netrider.rowland.org>
	<CAP_ceTzpN3QO8Xx3262Uowbfzf__BDC0P2g_t=UQ6VRCg184Jw@mail.gmail.com>
	<201109192308.06049.rjw@sisk.pl>
	<CAP_ceTyXLO=mv1Ott=g3mG0y+Q+VUM3N8CA-Fqa-_=uj7LTbmw@mail.gmail.com>
Date: Wed, 21 Sep 2011 11:22:50 -0700
X-Google-Sender-Auth: 5YJMkOMiMZ-Gc3lKNjGuhUCN_-Y
Message-ID: <CAE9FiQWwn1B0DyXVA9GiWhUr9kdeH9fVoE73UjBOwE2nqDNEVQ@mail.gmail.com>
Subject: Re: [RFC] PM / Runtime: decrease verbosity in kernel log
From: Yinghai Lu <yinghai.lu@oracle.com>
To: Vincent Palatin <vpalatin@chromium.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 10:24 AM, Vincent Palatin <vpalatin@chromium.org> wrote:
> On Mon, Sep 19, 2011 at 14:08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Monday, September 19, 2011, Vincent Palatin wrote:
>>> On Sat, Sep 17, 2011 at 09:23, Alan Stern <stern@rowland.harvard.edu> wrote:
>>> > On Fri, 16 Sep 2011, Vincent Palatin wrote:
>>> >
>>> >> When activating the PCI runtime PM on a laptop, my kernel log is filled with
>>> >> messages such as the following ones and can be hardly read to find interesting
>>> >> information:
>>> >> ehci_hcd 0000:00:1d.7: PME# disabled
>>> >> ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> >> ehci_hcd 0000:00:1d.7: setting latency timer to 64
>>> >> ehci_hcd 0000:00:1d.7: PCI INT A disabled
>>> >> ehci_hcd 0000:00:1d.7: PME# enabled
>>> >> ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0x92205000-0x922053ff] (PCI address [0x92205000-0x922053ff])
>>> >> ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10b)
>>> >> ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
>>> > ...
>>> >
>>> >> All those messages are triggered by the following cause, the laptop has a USB
>>> >> 3G modem with USB autosuspend activated. The USB device will wake up about
>>> >> every 30s to do some network related activities. Every time, the modem wakes
>>> >> up this triggers the wake up of the attached EHCI/PCI USB host controller
>>> >> which reconfigures its PCI interface, then everything go back to a suspended mode.
>>> >>
>>> >> Having the same 10 lines of log repeated is not really useful, but I probably
>>> >> cannot totally remove them since there are somewhat useful for PCI hotplug
>>> >> users and other PCI debugging.
>>> >> So, my proposal is to create a new dev_printk macro : "dev_printk_norpm" which
>>> >> outputs traces only when the device has not the runtime PM activated,
>>> >> and guard those traces with it.
>>> >> (cf the 2 patches in this thread as a PoC)
>>> >
>>> > Wouldn't it be easier just to change the existing messages to DEBUG
>>> > level?  Or are they more important than that?
>>>
>>> Yes, I can simply replace all those printk by dev_dbg traces. For my
>>> use case, it's perfect.
>>> My main concern was people using PCI hotplug, I think, then, their log
>>> will remain mostly silent when inserting a card, I don't know if this
>>> is acceptable or not.
>>
>> I think they don't really need that information except for debugging, right?
>
> I think so.
> I will send a new patch with dev_dbg in replacement of the noisy
> printks for PCI messages.
>

please use dev_printk(KERN_DEBUG,...) instead. otherwise will need
recompile the kernel with DEBUG enabled
to get debug message with debug in boot command line.

Yinghai
