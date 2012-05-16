Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966599Ab2EPNHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:07:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37457 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2EPNHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:07:11 -0400
Date: Wed, 16 May 2012 14:07:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, matt.fleming@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: use EFI to deal with platform wall clock
Message-ID: <20120516130700.GA21499@srcf.ucam.org>
References: <4FB265AB0200007800083CC5@nat28.tlf.novell.com>
 <20120515124707.GB25248@srcf.ucam.org>
 <4FB273EB0200007800083D32@nat28.tlf.novell.com>
 <20120515132006.GA26196@srcf.ucam.org>
 <4FB3B734020000780008415D@nat28.tlf.novell.com>
 <20120516123912.GA20990@srcf.ucam.org>
 <4FB3C0ED020000780008418E@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB3C0ED020000780008418E@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 01:59:57PM +0100, Jan Beulich wrote:
> >>> On 16.05.12 at 14:39, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Could you elaborate on that a little?
> 
> There are systems where RAM on individual nodes is always
> starting at e.g. a 1Tb boundary. Obviously there can (at
> least theoretically) be anything in between, and hence
> assuming that __va() is usable here is simply wrong, as likely
> no mapping was created at all for the hole space (or if there
> is one, it would conflict with the one to be established here
> in the EfiMemoryMappedIO case).

Ok, that does sound like it needs fixing.

> > Platforms don't correctly deal with the case where you make physical 
> > calls after ExitBootServices(). We tried running in physical mode. It 
> > simply doesn't work.
> 
> Interesting, especially as we're using physical mode exclusively so
> far in Xen. That's a platform issue though, and working around
> it by (silently!) sacrificing other functionality is questionable imo.
> It should at best be an option (default off), so that on systems
> where physical mode works, kexec can work too.

There was a patchset posted that provided that option. We experimented 
with it in RHEL for a while and found that physical mode simply isn't 
reliable - no other OS uses it, so it's entirely untested on most 
platforms.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
