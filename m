Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2AFRci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:32:38 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45381 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752842Ab2AFRcg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <20120103180020.GA15014@redhat.com>
References: <20111230193704.GA2874@redhat.com> <20120101145354.GA1791@elte.hu>
 <20120103093020.0cbcd735@jbarnes-desktop> <CAErSpo4YB6Rpe==-vbia9B_aJNtJ7BrDySs-jw5cGmeMv9zRgA@mail.gmail.com>
 <20120103180020.GA15014@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 6 Jan 2012 10:32:14 -0700
Message-ID: <CAErSpo6S19rznjbkos3LPk8K9GK=kFUr9+OqRfeZ72TiJpj35Q@mail.gmail.com>
Subject: Re: Dell Studio 1536 needs pci=nocrs to boot.
To: Dave Jones <davej@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 3, 2012 at 11:00 AM, Dave Jones <davej@redhat.com> wrote:
> On Tue, Jan 03, 2012 at 10:55:00AM -0700, Bjorn Helgaas wrote:
>  > On Tue, Jan 3, 2012 at 10:30 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>  > > On Sun, 1 Jan 2012 15:53:54 +0100
>  > > Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > >>
>  > >> * Dave Jones <davej@redhat.com> wrote:
>  > >>
>  > >> > Some machines don't boot unless passed pci=nocrs.
>  > >> > (See https://bugzilla.redhat.com/show_bug.cgi?id=770308 for details of
>  > >> >   one report. Waiting on dmidecode output for others).
>  > >> >
>  > >> > Currently there is a DMI whitelist, even though the default is on.
>  > >> >
>  > >> > This patch extends that dmi list to add a blacklist to automatically
>  > >> > apply disable it when necessary.
>  > >> >
>  > >> > Signed-off-by: Dave Jones <davej@redhat.com>
>  > >>
>  > >> Acked-by: Ingo Molnar <mingo@elte.hu>
>  > >>
>  > >> Jesse, will you take this one?
>  > >
>  > > Yeah, I can take it.  Bjorn, any comment (I'll bounce over the
>  > > original)?
>  >
>  > This is a band-aid, and we'll have to extend the blacklist for other
>  > machines, but it's the best we have right now, so I think it's the
>  > right thing to do.
>  >
>  > It's probably the same as
>  > https://bugzilla.kernel.org/show_bug.cgi?id=31602 (Dell 1546) and
>  > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/647043
>
> There's at least one more dell (Seems that entire 'studio' product line
> is affected) that I'm waiting on DMI data from.
> Also a thinkpad that I have a patch pending for.

I think we should drop the Dell 1536 blacklist entry from this patch
(adding set_nouse_crs() itself is fine and may be needed for other
machines).

The patches here: https://lkml.org/lkml/2012/1/5/402 should cover the
Dell 1536 issue as well as the Dell 1546 and any others with the same
BIOS defect.

Bjorn
