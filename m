Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1IUS0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 14:26:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1IUS0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 14:26:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [RFC] PM / Runtime: decrease verbosity in kernel log
Date: Wed, 21 Sep 2011 20:28:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        Sameer Nanda <snanda@chromium.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1316211355-2888-1-git-send-email-vpalatin@chromium.org> <CAP_ceTyXLO=mv1Ott=g3mG0y+Q+VUM3N8CA-Fqa-_=uj7LTbmw@mail.gmail.com> <CAE9FiQWwn1B0DyXVA9GiWhUr9kdeH9fVoE73UjBOwE2nqDNEVQ@mail.gmail.com>
In-Reply-To: <CAE9FiQWwn1B0DyXVA9GiWhUr9kdeH9fVoE73UjBOwE2nqDNEVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109212028.50187.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 21, 2011, Yinghai Lu wrote:
> On Wed, Sep 21, 2011 at 10:24 AM, Vincent Palatin <vpalatin@chromium.org> wrote:
> > On Mon, Sep 19, 2011 at 14:08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> On Monday, September 19, 2011, Vincent Palatin wrote:
> >>> On Sat, Sep 17, 2011 at 09:23, Alan Stern <stern@rowland.harvard.edu> wrote:
> >>> > On Fri, 16 Sep 2011, Vincent Palatin wrote:
> >>> >
> >>> >> When activating the PCI runtime PM on a laptop, my kernel log is filled with
> >>> >> messages such as the following ones and can be hardly read to find interesting
> >>> >> information:
> >>> >> ehci_hcd 0000:00:1d.7: PME# disabled
> >>> >> ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> >>> >> ehci_hcd 0000:00:1d.7: setting latency timer to 64
> >>> >> ehci_hcd 0000:00:1d.7: PCI INT A disabled
> >>> >> ehci_hcd 0000:00:1d.7: PME# enabled
> >>> >> ehci_hcd 0000:00:1d.7: BAR 0: set to [mem 0x92205000-0x922053ff] (PCI address [0x92205000-0x922053ff])
> >>> >> ehci_hcd 0000:00:1d.7: restoring config space at offset 0xf (was 0x100, writing 0x10b)
> >>> >> ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
> >>> > ...
> >>> >
> >>> >> All those messages are triggered by the following cause, the laptop has a USB
> >>> >> 3G modem with USB autosuspend activated. The USB device will wake up about
> >>> >> every 30s to do some network related activities. Every time, the modem wakes
> >>> >> up this triggers the wake up of the attached EHCI/PCI USB host controller
> >>> >> which reconfigures its PCI interface, then everything go back to a suspended mode.
> >>> >>
> >>> >> Having the same 10 lines of log repeated is not really useful, but I probably
> >>> >> cannot totally remove them since there are somewhat useful for PCI hotplug
> >>> >> users and other PCI debugging.
> >>> >> So, my proposal is to create a new dev_printk macro : "dev_printk_norpm" which
> >>> >> outputs traces only when the device has not the runtime PM activated,
> >>> >> and guard those traces with it.
> >>> >> (cf the 2 patches in this thread as a PoC)
> >>> >
> >>> > Wouldn't it be easier just to change the existing messages to DEBUG
> >>> > level?  Or are they more important than that?
> >>>
> >>> Yes, I can simply replace all those printk by dev_dbg traces. For my
> >>> use case, it's perfect.
> >>> My main concern was people using PCI hotplug, I think, then, their log
> >>> will remain mostly silent when inserting a card, I don't know if this
> >>> is acceptable or not.
> >>
> >> I think they don't really need that information except for debugging, right?
> >
> > I think so.
> > I will send a new patch with dev_dbg in replacement of the noisy
> > printks for PCI messages.
> >
> 
> please use dev_printk(KERN_DEBUG,...) instead. otherwise will need
> recompile the kernel with DEBUG enabled
> to get debug message with debug in boot command line.

Hmm?  I thought that using dev_dbg() was the recommended way?

Rafael
