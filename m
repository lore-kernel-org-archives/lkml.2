Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab0HCQC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 12:02:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:38706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab0HCQC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 12:02:26 -0400
Subject: Re: [linux-pm] Attempted summary of suspend-blockers LKML thread
From: James Bottomley <James.Bottomley@suse.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: paulmck@linux.vnet.ibm.com, peterz@infradead.org, swetland@google.com,
        linux-kernel@vger.kernel.org, florian@mickler.org,
        linux-pm@lists.linux-foundation.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	 <AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 11:02:18 -0500
Message-ID: <1280851338.2774.30.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 21:18 -0700, Arve Hjønnevåg wrote:
> > o       A power-aware application must be able to efficiently communicate
> >        its needs to the system, so that such communication can be
> >        performed on hot code paths.  Communication via open() and
> >        close() is considered too slow, but communication via ioctl()
> >        is acceptable.
> >
> 
> The problem with using open and close to prevent an allow suspend is
> not that it is too slow but that it interferes with collecting stats.

Please elaborate on this.  I expect the pm-qos stats interface will
collect stats across user open/close because that's how it currently
works.  What's the problem?

> The wakelock code has a sysfs interface that allow you to use a
> open/write/close sequence to block or unblock suspend. There is no
> limit to the amount of kernel memory that a process can consume with
> this interface, so the suspend blocker patchset uses a /dev interface
> with ioctls to block or unblock suspend and it destroys the kernel
> object when the file descriptor is closed.

This is an implementation detail only.  The pm-qos objects are long
lived, so their stats would be too.  I would guess that explicit stat
clearing might be a useful option.

James


