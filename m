Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1DWPpf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 11:45:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56027 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1DWPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 11:45:33 -0400
Message-ID: <4DB2F406.404@oracle.com>
Date: Sat, 23 Apr 2011 08:45:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arvind R <arvino55@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Jason Uhlenkott <juhlenko@akamai.com>
Subject: Re: linux-next: Tree for April 21 (i82975x_edac)
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>	<20110421085124.4a44d048.randy.dunlap@oracle.com> <BANLkTinoi1SeuuPj5SeTzssyBTvTQu6pMA@mail.gmail.com>
In-Reply-To: <BANLkTinoi1SeuuPj5SeTzssyBTvTQu6pMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DB2F410.0066:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/11 01:21, Arvind R wrote:
> On Thu, Apr 21, 2011 at 9:21 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:
>>
>>> Changes since 20110420:
>>
>>
>> on i386:
>>
>> drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for 'unsigned long' type
>>
>> which is:
>>
>>        if (info->xeap & 1)
>>                page |= 0x100000000ul; <<<<<<<<<<<<<<<
>>
>> but page is unsigned long (32 bits), while 0x100000000ul is more than 32 bits,
>> so that line isn't setting a bit in <page>.  Is it a bug, or this driver isn't
>> applicable to X86_32, or what?
>>
> would defining page variable to unsigned long long solve it for x86_32?

I think that the goal should be to get your 4-patch series merged.

> That would still not fix the wrong error-info reported by the driver - this is
> fixed by the patch-set titled '[RFC PATCH 2.6.37 0/4] i3000_edac : merge
> i82975x support' dated 2011-02-14 in the linux-edac archives.
> 
> Please advise on getting the patch into main-stream. The I3000 is a re-labeled
> i82975x (or vice-versa). Hence the patch-set to merge the drivers. If separate
> i82975x driver is needed - I can provide the patch. The reported bug is not
> present in the merge-patched driver.

Doug, any plans to merge this 4-patch series from Arvind?

Arvind, was bluesmoke-devel@lists.sourceforge.net copied on this patch series?

and was the I3000 driver maintainer copied?  (added)
I can't tell this from the marc.info archives.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
