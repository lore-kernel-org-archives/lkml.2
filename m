Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1CUU15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 16:27:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47386 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1CUU1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 16:27:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Exj7g92wgTloehre7GHKlLWB274Q1pz2R86f2GzIwrPrlAdcBuOGuBqGTwYU8n9xX3
         dfNTSizLqh77yJCRgXpmRUayl0JBu9d9IhJB7TDKr66M++on5u5vdGyHbJd4P35LLkFH
         YU4PKOKq12uIluMGKJcwrooOAI27QSvA5l3CA=
MIME-Version: 1.0
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C14F5A465@USINDEVS01.corp.hds.com>
References: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C14F5A465@USINDEVS01.corp.hds.com>
Date: Mon, 21 Mar 2011 13:27:54 -0700
X-Google-Sender-Auth: DF6g3WTv40dEaFQ7aTVyViRkxKE
Message-ID: <AANLkTinG0381opyEFtM4P-OuFoG++b7kvpTC4McoL9E8@mail.gmail.com>
Subject: Re: [RFC] pstore: Don't use persistent store for normal shutdown
From: Tony Luck <tony.luck@intel.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 12:49 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> I think we should save the tail of kernel log into persistent store
> for both every shutdown and kexec path because these data are useful
> in enterprise area.
>
> I already described the useful case in lkml (see below).
>
> normal shutdown:
> https://lkml.org/lkml/2010/11/17/249

I hadn't thought about the forensic opportunities to show that a reboot/halt
was the cause of a server shutdown - but these do look useful.  Should
I still try to save as much data in these cases? Saving 1 Kbyte would be
enough to have the last dozen+ lines, including the critical
    <0>[  536.970556] Restarting system.
that you'd like to see.

> kexec:
> https://lkml.org/lkml/2011/2/23/325

In the case of kexec used as a "fast reboot" to another kernel, it might
also be valid to save some small amount of kernel log - but in the case
of kexec to take a kernel dump after a serious problem, it might be good
to have as much kernel log as possible to make sure that we have no
gaps in saved data.  If there isn't an easy way to tell these two kexec
cases apart, we should just save more data in both cases.

I'll make a new patch incorporating these changes.

-Tony
