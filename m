Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab2LZWbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 17:31:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45511 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2LZWa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 17:30:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
Date: Wed, 26 Dec 2012 23:36:23 +0100
Message-ID: <6257154.ucqGyPHqkg@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CAE9FiQVOvqqEFXcRbZt5=8e4fQgmzw03WCS=env46eYADFpXLw@mail.gmail.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan> <CAE9FiQWr6-=kvrCXKEWFvUHHv6xbHKt-oAdt+VPUMphVUW4U4A@mail.gmail.com> <CAE9FiQVOvqqEFXcRbZt5=8e4fQgmzw03WCS=env46eYADFpXLw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 26, 2012 12:41:05 PM Yinghai Lu wrote:
> On Wed, Dec 26, 2012 at 12:16 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Wed, Dec 26, 2012 at 12:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> Do you have a reference for this?  I think this might have been true
> >> in the past, but I don't think it's true for any version of gcc we
> >> support for building Linux.
> >
> > http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3600.html
> 
> the problem is already addressed by:
> 
> | commit f9d14250071eda9972e4c9cea745a11185952114
> | Author: Linus Torvalds <torvalds@linux-foundation.org>
> | Date:   Fri Jan 2 09:29:43 2009 -0800
> |
> |    Disallow gcc versions 4.1.{0,1}
> |
> |    These compiler versions are known to miscompile __weak functions and
> |    thus generate kernels that don't necessarily work correctly.  If a weak
> |    function is int he same compilation unit as a caller, gcc may end up
> |    inlining it, and thus binding the weak function too early.
> |
> |    See
> |
> |        http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> |
> |    for details.
> 
> so it is ok to put the __weak in the same file now.

Cool, thanks for checking and for the ACK!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
