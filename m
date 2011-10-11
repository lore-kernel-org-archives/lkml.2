Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414Ab1JKV7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:59:38 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:54924 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751348Ab1JKV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:59:36 -0400
Message-ID: <4E94BC46.5080505@xenotime.net>
Date: Tue, 11 Oct 2011 14:59:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Andrei Warkentin <awarkentin@vmware.com>
CC: Namjae Jeon <linkinjeon@gmail.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: mmc core broken dependency on CONFIG_BLOCK (Was: linux-next:
 Tree for Oct 11 (mmc))
References: <1172297901.46681.1318361517579.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1172297901.46681.1318361517579.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 12:31, Andrei Warkentin wrote:
> Hi Randy,
> 
> ----- Original Message -----
>> From: "Randy Dunlap" <rdunlap@xenotime.net>
>> To: "Stephen Rothwell" <sfr@canb.auug.org.au>
>> Cc: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org, "Chris Ball"
>> <cjb@laptop.org>
>> Sent: Tuesday, October 11, 2011 2:49:39 PM
>> Subject: Re: linux-next: Tree for Oct 11 (mmc)
>>
>> On 10/11/11 02:11, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> The linux-next tree is now available from
>>> git://github.com/sfrothwell/linux-next.git as a temporary measure
>>> while
>>> the kernel.org servers are unavailable.
>>>
>>> It may also turn up on git.kernel.org (depending on the mirroring).
>>>  The
>>> patch set is still absent, however.
>>>
>>> Changes since 20111007:
>>
>>
>> When CONFIG_BLOCK is not enabled:
>>
>> In file included from
>> next-2011-1011/drivers/mmc/card/sdio_uart.c:43:0:
>> next-2011-1011/include/linux/mmc/card.h:175:12: error:
>> 'DISK_NAME_LEN' undeclared here (not in a function)
>>
>> Deleting the #include <linux/mmc/card.h> fixes the sdio_uart.c build.
>> However, the same problem occurs in mmc/core/core.c:
>>
> 
> Because linux/genhd is now included, oops. I'm pretty positive this is due to the "mmc : general purpose partition support" patch pulled recently. I am adding NamJae, who was the author.
> 
>> In file included from next-2011-1011/drivers/mmc/core/core.c:30:0:
>> next-2011-1011/include/linux/mmc/card.h:175:12: error:
>> 'DISK_NAME_LEN' undeclared here (not in a function)
>>
>> Should mmc/core/ depend on BLOCK?  or should it just be made
>> to build even when BLOCK is not enabled?
>>
> 
> I don't think there should be a direct dependency on BLOCK. I have two suggestions -
> 1) Have our own define similar to (and in fact smaller):
>    linux/genhd.h:#define DISK_NAME_LEN                     32
> 2) Put the MMC physical partition code under an #ifdef CONFIG_BLOCK, which is a reasonable
>    proposition, given that there wouldn't be any need to parse physical partition info if
>    it would never be consumed by the MMC block driver.
> 
> Thoughts?

Agreed on part 2).  Do part 1) if it is required, but it's usually better
not to duplicate constants or structs etc.
IOW, can DISK_NAME_LEN in linux/genhd.h be exposed even when CONFIG_BLOCK
is not enabled?



-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
