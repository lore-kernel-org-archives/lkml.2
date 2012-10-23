Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2JWAHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 20:07:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102Ab2JWAHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 20:07:04 -0400
Date: Mon, 22 Oct 2012 17:07:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: minyard@acm.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH 2/5] ACPI: Reorder IPMI driver before any other ACPI
 drivers
Message-Id: <20121022170703.03a11f39.akpm@linux-foundation.org>
In-Reply-To: <20121023000033.GA11756@srcf.ucam.org>
References: <1350420820-7156-1-git-send-email-minyard@acm.org>
	<1350420820-7156-3-git-send-email-minyard@acm.org>
	<20121022164538.3b707397.akpm@linux-foundation.org>
	<20121023000033.GA11756@srcf.ucam.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 01:00:34 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Mon, Oct 22, 2012 at 04:45:38PM -0700, Andrew Morton wrote:
> 
> > Relying upon link ordering is the old-fashioned way of doing things,
> > and I have vague memories that it only works by luck - that there's no
> > hard-and-fast rule that the linker has to obey what we think we asked
> > it to do.
> > 
> > The usual way of doing this sort of thing is to use the initcall
> > priority levels - core_initcall(), postcore_initcall(), etc.  Can that
> > be done here?
> 
> Not really - some of this code can be built as modules, so it's mostly 
> module_init rather than anything from the initcall family.
> 

hm.  So the ACPI code has found a way to defeat depmod? 
