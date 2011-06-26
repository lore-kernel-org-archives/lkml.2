Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab1FZULQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:11:16 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36932 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab1FZUJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:09:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q+Bq3NXyRUZHSRXtfi5bw0pwBVaEyV1SDAXwKYQW68j5rez556/65Ub1UnPEE0gVjB
         EzCU+wF3dued8qq2v3cgrQsPIu/5QBMDhCCr3xy6CgC6YSuiz54xfUvUSiiQvnxzX6sz
         VMYSUYoigIcpdnIewM/5gxLFMq9/wQhoKtrTg=
MIME-Version: 1.0
In-Reply-To: <1309081426.6618.0.camel@koala>
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>
	<20110624090456.191f1fda.randy.dunlap@oracle.com>
	<1308947172.13493.37.camel@koala>
	<4E04F5D0.9090900@oracle.com>
	<1308983721.23868.2.camel@koala>
	<20110625152009.f264be78.randy.dunlap@oracle.com>
	<BANLkTi=Q-7bCHaH+-z6gnbwvexpGLYH6pA@mail.gmail.com>
	<1309081426.6618.0.camel@koala>
Date: Mon, 27 Jun 2011 00:09:16 +0400
Message-ID: <BANLkTikUbL0d49mhrYYLy2ZvOF9Wa0b+mw@mail.gmail.com>
Subject: Re: linux-next: Tree for June 24 (mtd + of)
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: dedekind1@gmail.com
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Vitaly Wool <vwool@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/11, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Sun, 2011-06-26 at 00:11 -0600, Grant Likely wrote:
>> > 3.0-rc4 does not have this build error when I use the .config file with
>> > it...
>> > however, I think that 3.0-rc4 also does not build ofpart.ko as it
>> > should.
>> >
>> > Looks to me like changes in drivers/mtd/{Kconfig && Makefile} caused
>> > this
>> > build error.
>>
>> The following commit in linux-next appears to be the culprit:
>>
>> commit 1a6bc893044b961caae1c5a9c6c2065e608da427
>> Author: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> Date:   Sun May 29 21:32:33 2011 +0400
>>
>>     mtd: prepare to convert of_mtd_parse_partitions to partition parser
>>
>>     Prepare to convert of_mtd_parse_partitions() to usual partitions
>> parser:
>>     1) Register ofpart parser
>>     2) Internally don't use passed device for error printing
>>     3) Add device_node to mtd_part_parser_data struct
>>     4) Move of_mtd_parse_partitions from __devinit to common text section
>>     5) add ofpart to the default list of partition parsers
>>
>>     Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>>     Signed-off-by: Artem Bityutskiy <dedekind1@gmail.com>
>>
>> It adds a module_init() call to ofpart.c which does not work the way
>> that ofpart.c is linked to mtdcore.o.  Seems like that commit series
>> still needs work.
>
> OK, let's ask Dmitry to take a look at this.

Yes, I've forgot about this... ofpart can be made a simple module now.
I'll send two patches in five minutes or so.

-- 
With best wishes
Dmitry
