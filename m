Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1FXUja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 16:39:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45143 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1FXUj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 16:39:26 -0400
Message-ID: <4E04F5D0.9090900@oracle.com>
Date: Fri, 24 Jun 2011 13:38:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Vitaly Wool <vwool@ru.mvista.com>
Subject: Re: linux-next: Tree for June 24 (mtd + of)
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au>	 <20110624090456.191f1fda.randy.dunlap@oracle.com> <1308947172.13493.37.camel@koala>
In-Reply-To: <1308947172.13493.37.camel@koala>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E04F5DE.0082:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/11 13:26, Artem Bityutskiy wrote:
> On Fri, 2011-06-24 at 09:04 -0700, Randy Dunlap wrote:
>> On Fri, 24 Jun 2011 15:58:22 +1000 Stephen Rothwell wrote:
>>
>>> Hi all,
>>>
>>> Changes since 20110623:
>>>
>>> My fixes tree includes:
>>> 	(as an experiment) the early part of mmotm-2011-06-22-13-05
>>> 	STAGING: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE
>>
>>
>> When CONFIG_MTD=m, CONFIG_MTD_OF_PARTS=y:
>>
>> drivers/mtd/ofpart.o: In function `init_module':
>> ofpart.c:(.init.text+0x0): multiple definition of `init_module'
>> drivers/mtd/mtdcore.o:(.init.text+0x43): first defined here
> 
> I guess this is some old issue? I do not think ofpart can be compiled-in
> if the mtd core is a module...

[adding driver author, Vitaly]

No, it's a current issue.

config MTD_OF_PARTS
	def_bool y
	depends on OF

and (implicitly) depends on MTD.  MTD=m, so boolean => y.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
