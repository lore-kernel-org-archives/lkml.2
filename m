Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1DZXPU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 19:15:20 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:57496 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751898Ab1DZXPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 19:15:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Y6FBjLtpa/UXhd1sxtO+2M1rjKoyEuyqIxs+JsV45kQlcY7RFAWljWY7VVmslM+L0jHQcyVsmvLwRJIVeigJnjNsjaaDyb1ObDLHisZKbCRfrMlfwtvDw0vnceBu/UAz;
Date: Tue, 26 Apr 2011 16:15:16 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Foley <pefoley2@verizon.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] init/Kconfig: use if/endif to surround the EXPERT
 menu kconfig symbols
Message-Id: <20110426161516.02efca6f.rdunlap@xenotime.net>
In-Reply-To: <alpine.DEB.2.00.1104261608210.7639@chino.kir.corp.google.com>
References: <20110426130036.997a05fc.rdunlap@xenotime.net>
	<alpine.DEB.2.00.1104261608210.7639@chino.kir.corp.google.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 16:09:47 -0700 (PDT) David Rientjes wrote:

> On Tue, 26 Apr 2011, Randy Dunlap wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Surround the EXPERT menu with "if EXPERT" and "endif" so that it
> > is forced to stay as one unit.  Hopefully this will help to prevent
> > it being broken in the future.
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Peter Foley <pefoley2@verizon.net>
> > ---
> >  init/Kconfig |   36 ++++++++++++++++++++----------------
> >  1 file changed, 20 insertions(+), 16 deletions(-)
> > 
> > --- lnx-2639-rc4.orig/init/Kconfig
> > +++ lnx-2639-rc4/init/Kconfig
> > @@ -924,15 +924,17 @@ menuconfig EXPERT
> >            environments which can tolerate a "non-standard" kernel.
> >            Only use this if you really know what you are doing.
> >  
> > +if EXPERT
> > +
> >  config UID16
> > -	bool "Enable 16-bit UID system calls" if EXPERT
> > +	bool "Enable 16-bit UID system calls"
> >  	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
> >  	default y
> >  	help
> >  	  This enables the legacy 16-bit UID syscall wrappers.
> >  
> 
> I don't like this, people who look up a Kconfig option typically only 
> look at the single entry and look for dependencies within it, not the 
> context in which it is declared in the Kconfig file.

I think I know a bit about how that's done.

People should use tools to look at dependencies (like nconfig, xconfig, oldconfig).
They report dependencies correctly.

and this patch goes a long way toward preventing menu problems.

so I nak your (implied) nak.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
