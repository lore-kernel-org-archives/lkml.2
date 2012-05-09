Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab2EIJM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:12:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62677 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab2EIJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:12:24 -0400
Date: Wed, 9 May 2012 11:12:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ido Yariv <ido@wizery.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] vsmp: Fix number of CPUs when vsmp is disabled
Message-ID: <20120509091212.GA8585@gmail.com>
References: <1336462455-22544-1-git-send-email-ido@wizery.com>
 <tip-824a6ae65f085255464155760cb9628a2f0deb29@git.kernel.org>
 <20120508122548.GA5741@gmail.com>
 <20120509080335.GA5556@NoteStation.colubris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120509080335.GA5556@NoteStation.colubris.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ido Yariv <ido@wizery.com> wrote:

> Hi Ingo,
> 
> On Tue, May 08, 2012 at 02:25:49PM +0200, Ingo Molnar wrote:
> > 
> > On !CONFIG_SMP this produces the following build failure:
> > 
> >  arch/x86/kernel/vsmp_64.c:171:6: error: ‘setup_max_cpus’ undeclared (first use in this function)
> > 
> > Do you want to keep vSMP on UP? If not then you could add a 
> > 'depends on SMP' to the vSMP Kconfig entry, avoiding the whole 
> > UP problem space.
> 
> Oops, sorry for that.
> 
> vsmp_64.c is built even if CONFIG_X86_VSMP is not set, so even 
> if we set this dependency, it will not fix this issue.

Well, then fix the Makefile rule as well. Is there any point to 
using vSMP specific glue on UP kernels?

> How about the following CONFIG_SMP check instead?

Looks pretty ugly, because it just increases the config jungle 
instead of reducing it.

Thanks,

	Ingo
