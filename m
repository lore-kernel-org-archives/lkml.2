Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1KNRKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:10:07 -0500
Received: from smtp.newsguy.com ([74.209.136.69]:54213 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab1KNRKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:10:06 -0500
Message-ID: <4EC1592D.4060304@newsguy.com>
Date: Mon, 14 Nov 2011 10:08:45 -0800
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110917 Lightning/1.0b3pre Thunderbird/3.1.12
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: David Woodhouse <dwmw2@infradead.org>,
        Ivan Djelic <ivan.djelic@parrot.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org
Subject: Proposed change to mtd read functions (Was Re: [PATCH v2 07/16] mtd/docg3:
 add OOB layout to mtdinfo)
References: <1320912342-30147-1-git-send-email-robert.jarzmik@free.fr> <1320912342-30147-8-git-send-email-robert.jarzmik@free.fr> <4EBECB89.2020102@newsguy.com> <87vcqoiavr.fsf@free.fr> <1321188825.2273.4.camel@koala> <1321189398.2021.5.camel@shinybook.infradead.org> <1321191352.2273.14.camel@koala> <87ehxchta0.fsf@free.fr> <4EC020A2.9070003@newsguy.com> <1321216077.26585.11.camel@koala>
In-Reply-To: <1321216077.26585.11.camel@koala>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2011 12:27 PM, Artem Bityutskiy wrote:
> On Sun, 2011-11-13 at 11:55 -0800, Mike Dunn wrote:
>> An objection might be that mtd should not be setting policy.  It's also a fairly
>> sizeable modification.  The alternative would be to implement a mechanism to
>> return the corrected error count to the higher layer (e.g., ubi) for each read
>> operation.  This would be even more work, requiring modifications to mtd and ubi.
> Yeah, probably just returning the ECC correction count is cleaner
> design. Probably we can add another argument to the mtd read function
> and if the return code is -EUCLEAN (correctable bit-flips happened), it
> would contain the highest ECC correction count encountered while reading
> this region of the flash.


This would be better than the cumulative error count over the entire block,
because the highest count on any one page is more significant, I think.


>  So the SW which does not care, will not
> require any changes.
>
> I am not sure if you'll need to mtd interfaces from mtd->func(...) to
> mtd_func(mtd, ...) for this or not, though.


I don't (yet) see why I would need to. 

Just adding the argument to mtd->read(), mtd->read_oob(),  would be a simple
change, but large in scope, affecting all users of the mtd interface.  Any
advice on how to proceed?  Should it be one big patchset, with individual
patches for changes to mtd, nand, one_nand, mtdchar, each driver, ... ?  If it
is not all merged at once, the build will be broken for the unpatched
components.  Or is that acceptable, and the patches can be submitted piecemeal,
starting with, say, mtd, nand, nandsim, mtdram, mtdchar?  Or should we
temporarily create a branch from l2-mtd until we're satisfiled that this is all
stable?

Thanks,
Mike

> Artem.
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/
>
>

