Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1GCIfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:35:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50938 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab1GCIfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:35:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH] ACPI: fix acpi_power_off lockdep splat
Date: Sun, 3 Jul 2011 10:36:27 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Andrea Righi <andrea@betterlinux.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1309620681-25173-1-git-send-email-andrea@betterlinux.com> <201107030858.41459.rjw@sisk.pl> <20110703102137.302ac415@schatten.dmk.lab>
In-Reply-To: <20110703102137.302ac415@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107031036.28186.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 03, 2011, Florian Mickler wrote:
> On Sun, 3 Jul 2011 08:58:41 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Saturday, July 02, 2011, Andrea Righi wrote:
> > > Implement acpi_os_create_lock() as a C-preprocessor macro to assign
> > > unique lock_class_key to dynamically allocated locks and suppress wrong
> > > lockdep warnings.
> > > 
> > > This fixes:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=38152
> > > 
> > > Reported-by: Borislav Petkov <bp@alien8.de>
> > > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> > 
> > So, how exactly does it work?
> 
> The spin_lock_init macro stringifies it's argument and uses that as a
> name for the lock in the debugging.
> 
> By re-executing spin_lock_init (have not checked if that harms
> anything, but it should be ok) in the _macro_ the key changes from
> "lock" for all three locks to the actual argument
> "&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
> "&acpi_gbl_hardware_lock". 

OK, thanks for the explanation.

The proposed solution doesn't seem to be extremely straightforward,
but perhaps it's the simplest one.  I need to think about it a bit more.

Thanks,
Rafael
