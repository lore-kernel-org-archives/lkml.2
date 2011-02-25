Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab1BYUAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:00:08 -0500
Received: from kroah.org ([198.145.64.141]:49527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648Ab1BYUAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:00:06 -0500
Date: Fri, 25 Feb 2011 11:58:10 -0800
From: Greg KH <greg@kroah.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Mike Waychison <mikew@google.com>, Olof Johansson <olofj@chromium.org>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>,
        David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
Message-ID: <20110225195810.GB8860@kroah.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
 <20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
 <AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
 <AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8@mail.gmail.com>
 <AANLkTi=dE5_VjJ+5H6cWf9nAtdkLiqhSXo6Gvd_uGQ25@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=dE5_VjJ+5H6cWf9nAtdkLiqhSXo6Gvd_uGQ25@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 01:29:46PM -0800, Tony Luck wrote:
> On Wed, Feb 23, 2011 at 12:28 PM, Mike Waychison <mikew@google.com> wrote:
> > Ya, I don't think there is anything that guarantees that dmi_header is
> > aligned.   The access is probably the struct copy I did here:
> >
> >        /* Set the key */
> >        entry->dh = *dh;
> 
> Yup - looking back at the assembly I see that one of the 2-byte
> accesses is offset 2
> (picking up ->handle), but the second is offset 0 (picking up ->type
> and ->length). The
> compiler assumed the structure was 2-byte aligned because of ->handle.
> 
> > What if we changed that guy to use memcpy?  We'd probably need to
> > memcpy the dmi_system_event_log as well.  Patch attached (applies on
> > top of the entire patchset).
> 
> With the patch, all the unaligned accesses go away.
> 
> Tested-by: Tony Luck <tony.luck@intel.com>

Great!

Mike, care to resend this last patch as a 6/5 patch with a proper
subject, changelog comment, and signed-off-by: section so that I can
queue it up?

thanks,

greg k-h
