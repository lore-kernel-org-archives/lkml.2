Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab0KLKab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 05:30:31 -0500
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:32974 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756835Ab0KLKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 05:30:29 -0500
Message-ID: <4CDD1737.6010104@sciolus.org>
Date: Fri, 12 Nov 2010 10:30:15 +0000
From: "R.M. Thomas" <rmthomas@sciolus.org>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: [PATCH -next] staging/easycap: make module params private/static,
 fix build
References: <20101111125655.15fa7188.sfr@canb.auug.org.au> <20101111104422.28594510.randy.dunlap@oracle.com> <4CDC67FF.3010006@sciolus.org> <4CDC6BA4.3060307@oracle.com>
In-Reply-To: <4CDC6BA4.3060307@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On 11/11/10 14:02, R.M. Thomas wrote:
>> Randy Dunlap wrote:
>>> The easycap driver has module parameters (bars, gain, & debug)
>>> with global scope that intrude on the kernel namespace and cause
>>> build problems.  Change the names of them to be driver-specific
>>> and make 2 of them static.
>> I did do test builds of the driver in-tree prior to submitting the
>> recent set of patches, but did not see any warnings so did not spot
>> this mistake.  There's presumably something wrong with the way I'm
>> building the kernel.
> 
> This build problem shows up when this driver is built into the kernel
> image, not built as a loadable module.  Did you only build as a loadable
> module, maybe?  and what CPU architecture did you build for?  That could
> also matter.

Yes, that's it.  I do development of the driver on a machine running
Debian stable with 2.6.26.  I detect compilation and house-style
errors by copying the source into a clone of the linux-next tree and
running make and checkpatch.pl, but obviously I don't install.  To
test the run-time behaviour of the driver I copy the driver source to a
separate (sacrificial) machine which is actually running linux-next and
build the driver there out-of-tree as a loadable module, complete with
the installation step.  One machine is x86-64, the other is x86.

I'll change my way of working.

Mike
