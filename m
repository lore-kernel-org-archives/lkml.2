Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2K2KEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:04:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35959 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692Ab2K2KEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:04:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Zdenek Kabelac <zkabelac@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
Date: Thu, 29 Nov 2012 11:09:36 +0100
Message-ID: <1658287.3KNDf2oyAg@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50B724F9.7040504@redhat.com>
References: <50A513A8.9010404@redhat.com> <6072715.FoXSX1UJhO@vostro.rjw.lan> <50B724F9.7040504@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 29, 2012 10:03:53 AM Zdenek Kabelac wrote:
> Dne 28.11.2012 21:31, Rafael J. Wysocki napsal(a):
> > On Wednesday, November 28, 2012 06:27:50 PM Zdenek Kabelac wrote:
> >> Dne 28.11.2012 18:02, Linus Torvalds napsal(a):
> >>> On Wed, Nov 28, 2012 at 8:21 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> >>>>
> >>>> I've opened  https://bugzilla.kernel.org/show_bug.cgi?id=51071
> >>>> and attached picture there which is all I have.
> >
> > I wonder if you can try to apply the patch below and see if that makes any
> > difference?
> >
> 
> Yep - extended BZ with 2 new pictures - it's now crashing earlier within
> the call of acpi_bus_get_device().

Pretty much as expected.

So this is the problem I was thinking it was: the previous suspend-resume
cycle unregistered the struct acpi_device pointed to by dev->data in
pnpacpi_build_resource_template(), so the handle pointer in there is now
invalid.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
