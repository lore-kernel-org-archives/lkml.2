Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2HRNju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 09:39:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:34649 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755367Ab2HRNjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 09:39:47 -0400
Subject: Re: [PATCH] efi: add efi_runtime state checking
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Olof Johansson <olof@lixom.net>, Marko Kohtala <marko.kohtala@gmail.com>,
        linux-kernel@vger.kernel.org, mjg@redhat.com
In-Reply-To: <502AF27D.2010902@zytor.com>
References: <CAJ0yFaxO-ZU7d_RNbQ3y1cfB5EJL9wgvmgZk-nmkVOLoBRH88A@mail.gmail.com>
	 <1340832957-7386-1-git-send-email-olof@lixom.net>
	 <4FEB80A5.8020806@zytor.com>
	 <CAOesGMhzAmpX0sSFv4w+=Y4Uzh77aa3_QW3JW=eurfo22dRMoA@mail.gmail.com>
	 <502AF27D.2010902@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Aug 2012 14:39:18 +0100
Message-ID: <1345297158.3088.30.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 17:51 -0700, H. Peter Anvin wrote:
> On 06/28/2012 10:02 AM, Olof Johansson wrote:
> > On Wed, Jun 27, 2012 at 2:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >> On 06/27/2012 02:35 PM, Olof Johansson wrote:
> >>>
> >>> This adds an efi_runtime variable indicating whether the
> >>> efi runtime services are available. The only time they are
> >>> expected to not be available is when a 32-bit kernel has been
> >>> booted using 64-but EFI and vice versa.
> >>>
> >>> It also adds checking to the two locations where functions are
> >>> called; x86 reboot and efivars.
> >>>
> >>
> >> OK, stupid question:
> >>
> >> Why is this different from the efi_enabled variable, or rather: why is it
> >> different from what the efi_enabled variable *should* be?  If runtime
> >> services aren't available the only "EFI" that is available to the kernel are
> >> the data structures passed in, and those can be checked directly...
> >
> > Excellent question, and I think it would work to turn off efi_enabled
> > towards the end of setup_arch() for non-native boots. That'd solve all
> > these problems, I believe.
> >
> > I'll try it out and revise this patch. It might take me a day or two
> > to get cycles for it.
> >
> 
> Ping?

There's now a bugzilla report for tracking this,

	https://bugzilla.kernel.org/show_bug.cgi?id=45991



