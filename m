Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2D3Viw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 17:38:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756418Ab2D3Viv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 17:38:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oleksij Rempel <bug-track@fisher-privat.net>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
Date: Mon, 30 Apr 2012 23:43:34 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        Steven Rostedt <rostedt@goodmis.org>
References: <Pine.LNX.4.44L0.1204301348180.1558-100000@iolanthe.rowland.org> <4F9F0473.9090408@fisher-privat.net>
In-Reply-To: <4F9F0473.9090408@fisher-privat.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204302343.35215.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 30, 2012, Oleksij Rempel wrote:
> On 30.04.2012 19:53, Alan Stern wrote:
> > On Mon, 30 Apr 2012, Bjorn Helgaas wrote:
> > 
> >> On Sun, Apr 29, 2012 at 2:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>> From: Oleksij Rempel <bug-track@fisher-privat.net>
> >>>
> >>> This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
> >>> more closely and fixes suspend bug found on ASUS Zenbook UX31E.
> >>>
> >>> Some OEM use _SxD fileds do blacklist brocken Dx states.
> >>> If _SxD/_SxW return values are check before suspend as appropriate,
> >>> some nasty suspend/resume issues may be avoided.
> >>>
> >>> References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
> >>> Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
> >>> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >>> ---
> >>>
> >>> Bjorn, Len,
> >>>
> >>> This is -stable material and therefore v3.4 as well, IMO. �Please let me
> >>> know if one of you can take it or whether you want me to handle it all the
> >>> way to Linus.
> >>
> >> I'm OK with this from a PCI perspective.  Most of the change is in
> >> ACPI, so I propose that either you or Len take care of it.
> >>
> >> The second paragraph of the changelog has several typos
> >> (fileds/fields, do/to, brocken/broken, etc).
> > 
> > It also turns out that the normal wakeup mechanism doesn't work for the
> > devices in question.  Can this be detected by ACPI?  We don't want to 
> > tell userspace that wakeup works when in fact it doesn't.
> 
> hm... how about using pci config and acpi together. PCI config provides
> map of Dx states and wakeup support of them. If pci says wakeup works
> only on D0 and D3 and acpi say - we can use only D2 in S3, then there is
> no wakeup.

Not really.  ACPI trumps PCI here, so if ACPI says we can use D2 in S3,
then we can.

ACPI device states are not the same as PCI device states.  They usually map
to each other directly, but they don't have to.

Thanks,
Rafael
