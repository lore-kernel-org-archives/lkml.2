Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab2D3Rxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 13:53:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60417 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754920Ab2D3Rx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 13:53:29 -0400
Date: Mon, 30 Apr 2012 13:53:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bjorn Helgaas <bhelgaas@google.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        "Oleksij Rempel (fishor)" <bug-track@fisher-privat.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Rahmatullin <wrar@wrar.name>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ACPI / PCI: Make _SxD/_SxW check follow ACPI 4.0a spec
In-Reply-To: <CAErSpo7oGWNVeT6OCgaFdb_+uPAumggE-Z+OdnH=9aW+_N3B6g@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1204301348180.1558-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Bjorn Helgaas wrote:

> On Sun, Apr 29, 2012 at 2:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Oleksij Rempel <bug-track@fisher-privat.net>
> >
> > This patch makes _SxD/_SxW check follow the ACPI 4.0a specification
> > more closely and fixes suspend bug found on ASUS Zenbook UX31E.
> >
> > Some OEM use _SxD fileds do blacklist brocken Dx states.
> > If _SxD/_SxW return values are check before suspend as appropriate,
> > some nasty suspend/resume issues may be avoided.
> >
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=42728
> > Signed-off-by: Oleksij Rempel <bug-track@fisher-privat.net>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >
> > Bjorn, Len,
> >
> > This is -stable material and therefore v3.4 as well, IMO.  Please let me
> > know if one of you can take it or whether you want me to handle it all the
> > way to Linus.
> 
> I'm OK with this from a PCI perspective.  Most of the change is in
> ACPI, so I propose that either you or Len take care of it.
> 
> The second paragraph of the changelog has several typos
> (fileds/fields, do/to, brocken/broken, etc).

It also turns out that the normal wakeup mechanism doesn't work for the
devices in question.  Can this be detected by ACPI?  We don't want to 
tell userspace that wakeup works when in fact it doesn't.

Alan Stern

