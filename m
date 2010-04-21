Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0DUQ7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:59:23 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:18665 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0DUQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:59:20 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
Date: Wed, 21 Apr 2010 10:59:16 -0600
User-Agent: KMail/1.9.10
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
References: <20100409223532.GC11130@hexapodia.org> <201004210921.50502.bjorn.helgaas@hp.com> <4BCF2BBA.4080708@oracle.com>
In-Reply-To: <4BCF2BBA.4080708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004211059.17264.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010 10:45:46 am Yinghai Lu wrote:
> On 04/21/2010 08:21 AM, Bjorn Helgaas wrote:

> > Why are you doing this patch?  Did you see a machine where the host
> > bridge was left with no resources because of _CRS issues?  If so,
> > this patch feels like a band-aid.  I'd rather investigate the issue
> > directly, because that would probably be a Linux problem we could fix.
> >
> > Also, if there *is* a reported problem, you should include a link to
> > the bugzilla or email thread.
> >   
> No, just code review.

In that case, I don't think this patch is a good idea.  Assume we have
a Linux problem with _CRS parsing, and as a result, we don't find any
host bridge resources.  This patch will cause us to silently revert to
the default resources, so we lose the opportunity to debug and fix the
Linux problem.

Even worse, if there's a *BIOS* problem with _CRS, this patch will hide
it and make it harder to diagnose.

Bjorn
