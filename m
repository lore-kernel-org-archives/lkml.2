Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2CAS4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 13:56:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756251Ab2CAS4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 13:56:33 -0500
Date: Thu, 1 Mar 2012 13:31:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Eugene Surovegin <surovegin@google.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] kdump: force page alignment for per-CPU crash notes.
Message-ID: <20120301183115.GE13533@redhat.com>
References: <1330536083-13098-1-git-send-email-surovegin@google.com>
 <20120301150957.GA13533@redhat.com>
 <CANrfoUVMP5hPfm2R=C9eszS728YccKyWokUAa5Q5KN36+W83bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANrfoUVMP5hPfm2R=C9eszS728YccKyWokUAa5Q5KN36+W83bg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 09:04:32AM -0800, Eugene Surovegin wrote:
> On Thu, Mar 1, 2012 at 7:09 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Wed, Feb 29, 2012 at 09:21:23AM -0800, Eugene Surovegin wrote:
> >> Per-CPU allocations are not guaranteed to be physically contiguous.
> >> However, kdump kernel and user-space code assumes that per-CPU
> >> memory, used for saving CPU registers on crash, is.
> >> This can cause corrupted /proc/vmcore in some cases - the main
> >> symptom being huge ELF note section.
> >>
> >> Force page alignment for note_buf_t to ensure that this assumption holds.
> >>
> >
> > Hi Eugene,
> >
> > Where do we make assumption that crash_notes address is page aligned?
> 
> I never said that. I said that assumption was that note chunks were
> physically contiguous.
> 
> [snip]
> 
> > Are you referring to the fact that note could be stored on two different
> > physical pages and then kexec-tools does not know about the physical
> > address of second page, hence second kernel does not know about it
> > and we never read that data. That sounds like a problem.
> 
> Yes. This is exactly what happens in some cases.

Ok. Thanks for clarifying. Patch looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
