Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab2GLI4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 04:56:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab2GLI4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 04:56:46 -0400
Date: Thu, 12 Jul 2012 01:59:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chris@zankel.net" <chris@zankel.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>
Subject: Re: [PATCH 2/3] ipc: allow compat IPC version field parsing if
 !ARCH_WANT_OLD_COMPAT_IPC
Message-Id: <20120712015949.88692ecf.akpm@linux-foundation.org>
In-Reply-To: <20120712084756.GB2816@mudshark.cambridge.arm.com>
References: <1342020741-12758-1-git-send-email-will.deacon@arm.com>
	<1342020741-12758-3-git-send-email-will.deacon@arm.com>
	<20120711144001.b1f7c21d.akpm@linux-foundation.org>
	<20120712084756.GB2816@mudshark.cambridge.arm.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 09:47:56 +0100 Will Deacon <will.deacon@arm.com> wrote:

> > >  static inline int compat_ipc_parse_version(int *cmd)
> > >  {
> > > -#ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
> > > +#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
> > >  	int version = *cmd & IPC_64;
> > >  
> > >  	/* this is tricky: architectures that have support for the old
> > 
> > Could we do this purely in Kconfig?  Add a new
> > CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION and always set it true if
> > CONFIG_ARCH_WANT_OLD_COMPAT_IPC?
> 
> That would also work, although the current approach mirrors what is done for
> the native case (i.e. this is the compat equivalent of
> __ARCH_WANT_IPC_PARSE_VERSION).
> 
> I'm not too fussed either way, so I can change it if you prefer?

It would be best to change both as a separate patch.

It's not a big deal: just a matter of consistency and use of up-to-date
idioms.

