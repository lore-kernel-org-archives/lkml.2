Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0HBOLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:11:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0HBOLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:11:05 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Boot-time dynamic debugging?
Date: Mon, 2 Aug 2010 16:13:59 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, Greg KH <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, bjorn.helgaas@hp.com
References: <AANLkTiksVFpU+3iek4-TM2q=wSDGpW_nJAr8XtHT06LE@mail.gmail.com> <20100802134705.GA2836@redhat.com> <AANLkTi=k5nkUk9LOS=EGHGSq=5Qe8_L-1d3_t9byxMrt@mail.gmail.com>
In-Reply-To: <AANLkTi=k5nkUk9LOS=EGHGSq=5Qe8_L-1d3_t9byxMrt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008021614.00038.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 15:53:24 Pekka Enberg wrote:
> > On Sun, Aug 01, 2010 at 03:10:40PM +0300, Pekka Enberg wrote:
> >> Commit 346e15beb5343c2eb8216d820f2ed8f150822b08 ("driver core: basic
> >> infrastructure for per-module dynamic debug messages") removed
> >> "dynamic_printk" kernel parameter from the dynamic debugging subsystem
> >> (and forgot to update Documentation/kernel-parameters.txt). How can I
> >> use the new subsystem for enabling boot-time dev_dbg() calls for
> >> non-modular kernels?
> 
> On Mon, Aug 2, 2010 at 4:47 PM, Jason Baron <jbaron@redhat.com> wrote:
> > Right now, you can not enable them dynamically from the boot command
> > line (only via the debugfs file). However, Thomas Renninger, has posted
> > a series to add back the boot-time functionality, see:
> >
> > Subject:    [patch 0/3] Dynamic Debug providing early boot debug messages via
> > boot parameter
> > http://marc.info/?l=linux-kernel&m=127970474426120&w=2
> >
> > So I intend to queue those up for 2.6.36, and also update the
> > documentation.
> 
> Oh, great!
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Thanks.
> 
> Btw, can you easily enable all dev_dbg() calls with the boot parameter?
I expect yes, but never explicitly tried it, dev_dbg should result in
printk(KERN_DEBUG ...) after some macro/inline func processing.

Be aware that I sent another neat ddebug functionality:
Subject on LKML: [PATCH] Dynamic Debug: Introduce global fake module param module.ddebug

If, take the second post (same mail thread) which is the same patch
with some documentation added.
It's based on top of the patchseries mentioned above.
Would be great if someone could pick it up as well.
I was not sure about the fact that drivers must not use ddebug as parameter
anymore with this patch and how to document that, quick review and/or
comments appreciated.

Thanks,

      Thomas
