Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215Ab2JZOI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:08:58 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:40451 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111Ab2JZOI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:08:56 -0400
Message-ID: <508A9974.2090403@tilera.com>
Date: Fri, 26 Oct 2012 10:08:52 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Cyberman Wu <cypher.w@gmail.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: PCIe IO space support on Tilera GX: Is there any one who can
 confirm my modification to fix it is OK?
References: <CADCVGbTDD-4WOVJWwaGBvay5=of=3VKBCVacrrW-z12BYZ1xbQ@mail.gmail.com> <CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com>
In-Reply-To: <CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 4:03 AM, Bjorn Helgaas wrote:
> [+cc Chris, also a few comments below]

Bjorn, thanks for looping me in.

> On Fri, Oct 26, 2012 at 12:59 AM, Cyberman Wu <cypher.w@gmail.com> wrote:
>> After we upgrade to MDE 4.1.0 from Tilera, we encounter a problem that
>> only on HighPoint 2680 card works, I've
>> tried to fix it, but since most time I'm working in user space, I'm
>> not sure my fix is enough. Their FAE said that
>> the guy who add PCIe I/O space support is on vacation and I can't get
>> help from him now, I hope maybe there
>> will have somebody can help.

I asked internally and I think the response provided by Tilera was more
along the lines of "it may take a bit longer to get you an answer". :-)

> Per http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/01176.html,
> Chris considered adding I/O space support and decided against it at
> that time, partly because it would use up a TRIO PIO region.
>
> I don't know his current thoughts.  Possibly it could be done under a
> config option or something.

In the end, we did code up I/O port support in the root complex driver,
since we had a customer with a device that needed it.  We haven't yet
returned it to the community - getting the basic PCI root complex support
returned (and networking support) took way more time than I had anticipated
so I'm batching up the next round of stuff to return for later.  But
"later" is probably going to come fairly soon since it would make sense to
target the 3.8 merge window.

>> It works now. But I really need some one to confirm whether my
>> modification is enough or not,
>> if there have other potential problems.

Cyberman: it seems like your bias hack is working for you.  But, as Bjorn
says, this sounds like a driver bug.  What happens if you just revert your
changes, but then in mvsas.c change the "if (!res_start || !res_len)" to
just say "if (!res_len)"?  That seems like the true error test.  If that
works, you should submit that change to the community.

Bjorn et al: does it seem reasonable to add a bias to the mappings so that
we never report a zero value as valid?  This may be sufficiently defensive
programming that it's just the right thing to do regardless of whether
drivers are technically at fault or not.  If so, what's a good bias?  (I'm
inclined to think 64K rather than 4K.)

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

