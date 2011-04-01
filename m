Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab1DAPpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:45:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57130 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DAPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kMzv7Ny+89OZlZZulujnS1xM5NlXjc+9C3NBh/34xosJ8mKztcc+1T8oYS2KmAvEDR
         w8zFKDQj5qalnUJs7qQVFr12SiYVFjv/z28dTHpFrgN3ZU5DUoBxvJbJWmkpC5ft04mW
         awu/29/Iny/j1UnnwF5M8DKOyFCRIslTJm6tw=
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D95F092.4080604@grupopie.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	 <4D948D52.4040708@grupopie.com>  <1301669776.2789.92.camel@localhost>
	 <1301670104.2789.94.camel@localhost>  <4D95F092.4080604@grupopie.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 18:42:29 +0300
Message-ID: <1301672549.2789.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 16:34 +0100, Paulo Marques wrote:
> Artem Bityutskiy wrote:
> > On Fri, 2011-04-01 at 17:56 +0300, Artem Bityutskiy wrote:
> >> Well, ok, I've measured how much is this "a lot". On an embedded arm
> >> platform this makes the kernel only 1.5% larger. 
> > 
> > But in absolute numbers this is 70KiB in my case, which is indeed
> > considerable amount. So, I agree that it makes sense to keep this as a
> > separate option.
> 
> Yes, and this depends a lot on the kernel configuration options you've
> selected (and that 1.5% of the kernel size, might be 50%~100% of the
> kallsyms table).
> 
> IIRC, I had configurations where the KALLSYMS_ALL option was increasing
> the kallsyms table from something like 150kB to above 500kB (before
> compression). This was a long time ago though and I can't say exactly
> what was the configuration that made this happen.

Yes, thanks, I agree that having 2 separate options is OK.

> As for the CONFIG_KALLSYMS_EXTRA_PASS, I think the original idea (it was
> not mine) was that it should be off by default and then the user would
> need to turn it on when something went wrong.

Yes, but my point is that this feature is about the build and it does
not affect run-time, so it should not be in Kconfig.

> With an automatic makefile mechanism, the problem would go unnoticed and
> it just wouldn't be fixed, increasing the kernel compile time for
> everyone who hits the same troublesome configuration.

Yes, the build system may print a message:

Your symbols table is screwed, this is a bug, report about it. As a
temporary workaround use "make KALLSYMS_EXTRA_PASS=1"

Or something like that.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

