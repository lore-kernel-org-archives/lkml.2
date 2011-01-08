Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1AHWqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 17:46:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:36832 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1AHWql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 17:46:41 -0500
Message-ID: <4D28E945.3060504@suse.com>
Date: Sat, 08 Jan 2011 17:46:29 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
Cc: Dan Carpenter <error27@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, balbir@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] taskstats: Use better ifdef for alignment
References: <4D1BCE58.4000902@suse.com>	<20101229161418.d34bf0d4.akpm@linux-foundation.org>	<4D1C180A.20000@suse.com>	<20101229213243.891b0db5.akpm@linux-foundation.org>	<4D1CAAA1.8030106@suse.com>	<20110101171946.6179c3b6@schatten.dmk.lab>	<20110101165135.GJ1886@bicker> <20110102131747.3e79107a@schatten.dmk.lab>
In-Reply-To: <20110102131747.3e79107a@schatten.dmk.lab>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/02/2011 07:17 AM, Florian Mickler wrote:
> On Sat, 1 Jan 2011 19:51:35 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
>> On Sat, Jan 01, 2011 at 05:19:46PM +0100, Florian Mickler wrote:
>>> Is there already a patch available or integrated into iotop which
>>> fixes this? I'd think that if the kernel could wait on fixed iotop's to
>>> be distributed it would be easier to sell the breakage on bugzilla &
>>> co...
>>>
>>
>> The story is that 4be2c95d1f "taskstats: pad taskstats netlink response
>> for aligment issues on ia64" broke iotop on 64 bit processors (32 bit
>> was unaffected).  This patch fixes it for x86-64 and powerpc-64.
>>
>> On the other 64 bit processors iotop works but instead you get a message
>> in dmesg:
>> kernel unaligned access to 0xe000023879dca9bc, ip=0xa000000100133d10
>>
>> So on those arches you were already getting posts to bugzilla etc.  Now
>> those people can upgrade the kernel and download iotop version 0.4.2 or
>> higher.
>>
>> regards,
>> dan carpenter
>>
> 
> Ah ok. And probably bug #24272 is related to this. If I
> understood it correctly 85893120 fixed some runtime warnings (or more
> exactly the misaligning) and broke iotop in the process (on all of 64
> bit). 
> 
> 4be2c95d1f undid that and enhanced the netlink messages on  IA64
> archs with a new type to fix the alignment and now it's changed to
> align well on all archs that need alignment, leaving archs unbroken that
> have efficient unaligned access (x86-64 and powerpc-64). Nice. 
> 
> And to answer my original question, i just checked out (some?/the?)
> iotop sources from git://repo.or.cz/iotop.git and found a fix[1] for the
> issue with 85893120. 
> 
> Is iotop parsing fixed to ignore the null-field in the meantime?

It isn't yet, but I sent Guillaume a patch to iotop when I sent in the
null-field patch that actually parses the packet instead of doing
field-offset tricks.

- -Jeff

> Thx,
> Flo
> 
> [1]git://repo.or.cz/iotop.git:commit 08211d209ae8fc7e67ea3bebb09979ff61c70f97
> Author: Guillaume Chazarain <guichaz@gmail.com>
> Date:   Sat Sep 4 13:57:43 2010 +0200
> 
>     Instead of assuming the pid field is 4 bytes long, take its length from the header.
>     This is needed for http://lkml.org/lkml/2010/2/12/167
>     [PATCH] delayacct: align to 8 byte boundary on 64-bit systems


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0o6UUACgkQLPWxlyuTD7Is/wCfTUBE/2hg19vfGO2Wzk3Zkguo
mW8AnAv6ey78E7dJsvkKLy/YS6vW10cE
=fUIp
-----END PGP SIGNATURE-----
