Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab0JZWfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 18:35:00 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:41225 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758229Ab0JZWe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 18:34:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=JxSI6zeZOJ/IZvWdaFFE0d987RlP3qze6WMl6uYYK1VVnI5qDHVgn+/R1254LduUBK9uEwYfV8NsvPh+tloSAl92Iqn9LCQisEbCI7fxaoEzWf4qcG4+8VhjHLPdo4BY;
Date: Tue, 26 Oct 2010 15:34:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
        Fabrice Bellet <fabrice@bellet.info>, Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5 9/9] x86: allocate space within a region top-down
Message-ID: <20101026153455.0fe4847f@jbarnes-desktop>
In-Reply-To: <20101026214154.29808.58672.stgit@bob.kio>
References: <20101026214033.29808.15272.stgit@bob.kio>
	<20101026214154.29808.58672.stgit@bob.kio>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Oct 2010 15:41:54 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> Request that allocate_resource() use available space from high addresses
> first, rather than the default of using low addresses first.
> 
> The most common place this makes a difference is when we move or assign
> new PCI device resources.  Low addresses are generally scarce, so it's
> better to use high addresses when possible.  This follows Windows practice
> for PCI allocation.
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c42
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---

Ok, applied this version to -next.  It's been going through distros and
lots of testing despite a lack of recent coverage in PCI -next, so I'm
planning to send it to Linus this week.  We probably won't catch much
more until it hits his tree anyway...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
