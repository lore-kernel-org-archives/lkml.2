Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab1DAPeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:34:50 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:33780 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab1DAPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:34:49 -0400
Message-ID: <4D95F092.4080604@grupopie.com>
Date: Fri, 01 Apr 2011 16:34:42 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>	 <4D948D52.4040708@grupopie.com>  <1301669776.2789.92.camel@localhost> <1301670104.2789.94.camel@localhost>
In-Reply-To: <1301670104.2789.94.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Fri, 2011-04-01 at 17:56 +0300, Artem Bityutskiy wrote:
>> Well, ok, I've measured how much is this "a lot". On an embedded arm
>> platform this makes the kernel only 1.5% larger. 
> 
> But in absolute numbers this is 70KiB in my case, which is indeed
> considerable amount. So, I agree that it makes sense to keep this as a
> separate option.

Yes, and this depends a lot on the kernel configuration options you've
selected (and that 1.5% of the kernel size, might be 50%~100% of the
kallsyms table).

IIRC, I had configurations where the KALLSYMS_ALL option was increasing
the kallsyms table from something like 150kB to above 500kB (before
compression). This was a long time ago though and I can't say exactly
what was the configuration that made this happen.

As for the CONFIG_KALLSYMS_EXTRA_PASS, I think the original idea (it was
not mine) was that it should be off by default and then the user would
need to turn it on when something went wrong.

With an automatic makefile mechanism, the problem would go unnoticed and
it just wouldn't be fixed, increasing the kernel compile time for
everyone who hits the same troublesome configuration.

-- 
Paulo Marques - www.grupopie.com

"As far as we know, our computer has never had an undetected error."
Weisert

