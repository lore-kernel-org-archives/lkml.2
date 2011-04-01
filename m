Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1DAOsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:48:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46019 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1DAOnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:43:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o5LIFOVmfQEuviQez6m1mZq1EwPj4HrBeSsU9B2gVLeoe/gUjd7qO27cUDYQeTDXOx
         lhkFKg1X0/Sj52RUY6YyeMxl6IpycWyOmQh2i/x+v33A68nXYHM7KP8IrQD5MUpJA7Mf
         kyBBphNy/Hde/2E3Cv6mU4IdjfW9MptbC36PE=
Subject: Re: [PATCH 0/2] do not select KALLSYMS_ALL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Paulo Marques <pmarques@grupopie.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        MTD list <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4D948D52.4040708@grupopie.com>
References: <1301474416-8202-1-git-send-email-dedekind1@gmail.com>
	 <4D948D52.4040708@grupopie.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 17:40:33 +0300
Message-ID: <1301668833.2789.90.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 15:18 +0100, Paulo Marques wrote:
> Artem Bityutskiy wrote:
> > [...]
> > I personally think KALLSYMS_ALL should be just merged with KALLSYMS and
> > disappear - we should have only one option. CONFIG_KALLSYMS_EXTRA_PASS should
> > die as well.
> 
> That sounds a little too extreme...
> 
> KALLSYMS is useful for most kernels, since it provides nice readable
> stack dumps for panics and BUG's.
> 
> KALLSYMS_ALL adds a lot of extra symbols that can be useful mostly to
> development kernels and shouldn't be used to add unnecessary bloat to
> user kernels.

OK, thanks.

> Now as for CONFIG_KALLSYMS_EXTRA_PASS: to build the kallsyms table, the
> build process first links a kernel image with an empty kallsyms table
> and use that to fetch information for all the symbols.
> 
> It then uses that information to build the table with the right size,
> and links it again. If everything goes ok, this new version as all the
> symbols in the correct places and the final table can be built with the
> correct addresses.
> 
> The final linking should produce the same result as only the data on the
> kallsyms table changed, but not its size.
> 
> However, there have been bugs in the past with section alignments and
> symbol reordering for symbols with the same address, etc., etc. that
> make this final table not have the exact same size, and the build fails
> with an inconsistent kallsyms data message. At this point, the user can
> turn on the CONFIG_KALLSYMS_EXTRA_PASS and temporarily solve the problem
> while the developers find the correct fix. Without this option, in this
> situation the kernel would simply fail the compilation.
> 
> All this has been stable for a while and this option hasn't been needed
> recently (AFAIK), but if there is some bug in some new binutils or
> something, the option might be needed again.

Thanks for explanation!

But... why on earth this option is in Kconfig then, if this is only
about extra pass during the kernel _compilation_ ? This and the vague
help message in Kconfig help section are very misleading. This should
not be in Kconfig at all then, it should be purely a Makefile thing!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

