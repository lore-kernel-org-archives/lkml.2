Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab1GXRNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 13:13:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:40194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab1GXRN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 13:13:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=esthbg/BPDooonqh1eIL8RACkRzBzc51B8rg5Ncw9Rlr8DIYyyWaT4xBI9vuNrFiD8r9RhxwvuGfQaemZTCHu0yrvPv9UxGLTAJOuPAnb0MCEV16+Mj7yN+8odM0/T4o;
Date: Sun, 24 Jul 2011 10:13:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Daniel Drake <dsd@laptop.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: OLPC power management patches - merge for 3.1?
Message-Id: <20110724101323.d5c9bc5a.rdunlap@xenotime.net>
In-Reply-To: <CAGq3pz6L5VzYaGBN8Py3x9s-orAp9AoG1OMM=1p8KJ1b3TVR6Q@mail.gmail.com>
References: <CAGq3pz4VHgagUQ+jGJdt9LL4UnFt+CDgcLLXbuVeKfWMc=0wAA@mail.gmail.com>
	<20110723202032.67ebdbcc.rdunlap@xenotime.net>
	<CAGq3pz6L5VzYaGBN8Py3x9s-orAp9AoG1OMM=1p8KJ1b3TVR6Q@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
X-Greylist: Delayed for 23:33:43 by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Sun, 24 Jul 2011 17:13:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 09:59:20 +0100 Daniel Drake wrote:

> On 24 July 2011 04:20, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > I have no objection to merging OLPC patches, but they should build
> > without errors.
> 
> Agreed! Thanks for reporting the issue.
> 
> > Looks like this problem is caused by:
> >
> > config OLPC_XO1_SCI
> >        bool "OLPC XO-1 SCI extras"
> >        depends on OLPC && OLPC_XO1_PM && POWER_SUPPLY
> >
> > or
> > config OLPC_XO15_SCI
> >        bool "OLPC XO-1.5 SCI extras"
> >        depends on OLPC && ACPI && POWER_SUPPLY
> >
> > In both cases, the 'bool' depends on one or more tristate symbols, so
> > the tristates are satisfied if they are =m or =y.  This should work fine
> > if these kconfig symbols (listed above) were tristate instead of bool.
> 
> In this case, we do need them to be bool options. At least for now. We
> tried for a modular design earlier in the review process but it added
> too much complexity.
> 
> So, whats the best way to fix the Kconfig? Should we:

If I knew a good solution, I would have posted it.

> depends on POWER_SUPPLY=y

You could do that.

> or
> 
> depends on POWER_SUPPLY
> select POWER_SUPPLY
> 
> ?

You can't do both of those AFAIK -- and it already depends on POWER_SUPPLY.
I guess you could remove "depends on POWER_SUPPLY" and add "select POWER_SUPPLY".
I'll see if that works.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
