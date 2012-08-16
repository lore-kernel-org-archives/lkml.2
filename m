Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab2HPKXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:23:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43945 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754385Ab2HPKXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:23:07 -0400
Date: Thu, 16 Aug 2012 11:23:00 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/31] arm64: ELF definitions
Message-ID: <20120816102300.GG31784@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-17-git-send-email-catalin.marinas@arm.com>
 <201208151415.39570.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208151415.39570.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 03:15:39PM +0100, Arnd Bergmann wrote:
> On Tuesday 14 August 2012, Catalin Marinas wrote:
> > +
> > +void elf_set_personality(int personality)
> > +{
> > +       switch (personality & PER_MASK) {
> > +       case PER_LINUX:
> > +               clear_thread_flag(TIF_32BIT);
> > +               break;
> > +       case PER_LINUX32:
> > +               set_thread_flag(TIF_32BIT);
> > +               break;
> > +       default:
> > +               pr_warning("Process %s tried to assume unknown personality %d\n",
> > +                          current->comm, personality);
> > +               return;
> > +       }
> > +
> > +       current->personality = personality;
> > +}
> > +EXPORT_SYMBOL(elf_set_personality);
> 
> This looks wrong: PER_LINUX/PER_LINUX32 decides over the output of the
> uname system call, while TIF_32BIT decides over the instruction set
> when returning to user space. You definitely should not set the personality
> to the value you pass from the elf loader. Instead, just do
> 
> #define SET_PERSONALITY(ex) clear_thread_flag(TIF_32BIT);
> #defined COMPAT_SET_PERSONALITY(ex) set_thread_flag(TIF_32BIT);

In this case, won't uname be incorrect (aarch64l) for aarch32 tasks (which
expect something like armv8l)?

Will
