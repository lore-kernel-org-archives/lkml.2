Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab0LOAMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:12:42 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20517 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab0LOAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:12:40 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/5] resources: add arch hook for preventing allocation in reserved areas
Date: Tue, 14 Dec 2010 17:09:45 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Adam Belay <abelay@mit.edu>, Matthew Garrett <mjg@redhat.com>,
        Dan Williams <dcbw@redhat.com>
References: <20101208213606.13026.47657.stgit@bob.kio> <20101213054334.GA15856@helgaas.com> <20101213134739.GA27941@elte.hu>
In-Reply-To: <20101213134739.GA27941@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012141709.46610.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 13, 2010 06:47:39 am Ingo Molnar wrote:
> 
> * Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > > OK, so I guess the best thing we can do for 2.6.37 is to revert 1af3c2e (x86: 
> > > allocate space within a region top-down), right?
> > 
> > That's a possibility, but I'm not sure it's the best.  It would avoid the nx6325 
> > landmine, but we could easily step on a different one on other machines.
> > 
> > If Windows uses the end of available space first, that's the best-tested 
> > territory, and I think it's better to try to stay in it rather revert 1af3c2e and 
> > start mapping different territory that really isn't tested by Windows at all.
> > 
> > On the nx6325, we stray out of that tested territory because Linux opens windows 
> > on subtractive-decode bridges and allocates more space to CardBus bridges.
> > 
> > I think it'd be fairly simple to leave subtractive-decode bridges alone, and that 
> > might make the nx6325 work well enough for .37, even without the quirk.  This 
> > feels like a change that might be the right thing to do in general.  Using 
> > subtractive rather than positive decode would give up a little performance, but I 
> > doubt it's important
> 
> Is there a patch for that that people could try?

Yes.  https://bugzilla.kernel.org/show_bug.cgi?id=23332#c22

It works for me, but it's such a new idea to me that I'm not quite
used to it and don't know how confident to be yet.

Bjorn
