Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab0LLEQV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 23:16:21 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48762 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752507Ab0LLEQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 23:16:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zd2I/4lddPzCFYimfJSE59HIXhyWwbij04UeH/P7SX7fAGfuWAuFVbrScoVMcLTxwBKIn8cKv3+eNwxdYiYD0G7fHTXiQLJ4SHOAbBfkvbAmIyxGF9ofndY6oVEkbzp6;
Date: Sat, 11 Dec 2010 20:16:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Len Brown <lenb@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Adam Belay <abelay@mit.edu>, Matthew Garrett <mjg@redhat.com>,
        Dan Williams <dcbw@redhat.com>, rjw@sisk.pl
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation
 in reserved areas
Message-ID: <20101211201615.79186de7@jbarnes-desktop>
In-Reply-To: <AANLkTi=b5pq+RhA1DpyyRaLEQxQFOrf4aEXHrG-Qjqbt@mail.gmail.com>
References: <20101208213606.13026.47657.stgit@bob.kio>
	<20101210123008.7fed582d@jbarnes-desktop>
	<20101210123609.73c12a23@jbarnes-desktop>
	<201012101407.24419.bjorn.helgaas@hp.com>
	<20101210173749.7ec3cc28@jbarnes-desktop>
	<AANLkTi=b5pq+RhA1DpyyRaLEQxQFOrf4aEXHrG-Qjqbt@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Dec 2010 19:34:05 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Dec 10, 2010 at 5:37 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Thanks, I'll add Dan and Rafael's tested-bys to the patches (they're
> > already in my for-linus tree).  Unless Linus has a problem with them
> > I'll send them over to him this weekend or Monday.
> 
> See my other email I just sent out.
> 
> I really am not going to take some totally new experimental and hacky
> major PCI resource management thing this late in the -rc game. No way,
> no how.
> 
> If the top-down allocator is causing regressions that cannot be fixed
> by _simple_ patches, we're simply going to have to undo it. What's the
> advantage of top-down? None. Not if we then need all this crap, which
> we could as easily do on top of the bottom-up one WITHOUT any
> regressions.
> 
> Why isn't anybody else questioning the whole basic premise here?

Questioning the whole premise is fine, but so far we've gone in (or at
least think we're going in) a consistent direction: behave like Windows
on platforms designed for Windows to avoid bugs that Windows doesn't
hit and enable all the same devices Windows allows.

But yes, I really don't like the nx6325 patch either; there's obviously
something we're still missing that's preventing us from doing the right
thing on that platform.  Quirking it isn't a good long term answer.

-- 
Jesse Barnes, Intel Open Source Technology Center
