Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab2FHFkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:40:52 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:19000 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933517Ab2FHFku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:40:50 -0400
Date: Fri, 8 Jun 2012 07:40:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120608054048.GA18796@merkur.ravnborg.org>
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com> <4FCDDB7D0200007800088390@nat28.tlf.novell.com> <20120605144734.GU32472@redhat.com> <20120605161318.GA29751@merkur.ravnborg.org> <4FCE4D800200007800088546@nat28.tlf.novell.com> <20120605172208.GA29862@merkur.ravnborg.org> <20120608020654.GA18530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608020654.GA18530@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:06:54PM -0400, Don Zickus wrote:
> On Tue, Jun 05, 2012 at 07:22:08PM +0200, Sam Ravnborg wrote:
> > > >> I do not know enough about behind the scene compiler magic to track this
> > > >> down correctly.  So any insight/help is greatly appreciated. :-)
> > > > 
> > > > We register a function annotated __init. And the normal use of this 
> > > > register()
> > > > is for functions that survive the init phase.
> > > > So drop the __init annotation on the function we register and the mismatch 
> > > > is fixed.
> > > 
> > > But in the case here the function really is being used at init time
> > > only.
> > This is only for testing. Ando nly if CONFIG_DEBUG_NMI_SELFTEST is set.
> 
> Hi Sam,
> 
> Sorry for ignoring your responses before.  Somehow your emails were not
> hitting my inbox for some reason, but I found them in my lkml folder.
> 
> So I am confused on the right way to fix this.
> 
> Sam is saying drop the __init and Jan is suggesting add __initdata for
> these two special cases.
> 
> Anyone want to break the tie? :-)

IMO Jan's approach with __initdata is overkill, but I do not care
much about it.

	Sam
