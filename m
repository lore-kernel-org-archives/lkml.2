Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0JPTxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 15:53:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0JPTxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 15:53:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Stewart <pstew@google.com>
Subject: Re: [PATCH] ath9k: Convert to new PCI PM framework
Date: Sat, 16 Oct 2010 21:52:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc8-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
References: <201010160036.17653.rjw@sisk.pl> <AANLkTimXXERRCYEjzQbcii6XW8wbjNfN-eWigU7Wi_Lv@mail.gmail.com>
In-Reply-To: <AANLkTimXXERRCYEjzQbcii6XW8wbjNfN-eWigU7Wi_Lv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010162152.24344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 16, 2010, Paul Stewart wrote:
> On Fri, Oct 15, 2010 at 3:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >
> > The ath9k driver uses the legacy PCI power management (suspend
> > and resume) callbacks that apparently cause intermittent problems
> > to happen (the adapter sometimes doesn't resume correctly on my
> > Acer Ferrari One).  Make it use the new PCI PM and let the PCI core
> > code handle the PCI-specific details of power transitions.
> I'm curious.  What sort of behavior did you get when the device fails
> to resume correctly?  Every now and then I've been getting bad
> accesses to 0x7000 every now and then -- after that any reads to PCI
> registers return all f's.

Yes, this sort of matches my experience.  Even the config space isn't
really accessible after a failure to resume.

Thanks,
Rafael
