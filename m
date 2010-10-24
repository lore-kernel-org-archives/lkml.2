Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0JXBgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:36:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38837 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0JXBgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:36:19 -0400
Message-ID: <4CC38D8F.7010104@oracle.com>
Date: Sat, 23 Oct 2010 18:36:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: Re: 2.6.36, make oldconfig broken
References: <201010221229.36996.gene.heskett@gmail.com> <201010221608.36754.gene.heskett@gmail.com> <4CC20011.5010809@oracle.com> <201010222054.52066.gene.heskett@gmail.com>
In-Reply-To: <201010222054.52066.gene.heskett@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/10 17:54, Gene Heskett wrote:
> On Friday, October 22, 2010, Randy Dunlap wrote:
>> On 10/22/10 13:08, Gene Heskett wrote:
>>> On Friday, October 22, 2010, Randy Dunlap wrote:
>>>> On Fri, 22 Oct 2010 12:29:36 -0400 Gene Heskett wrote:
>>>>
>>>> [adding linux-kbuild]
>>>>
>>>>> Greets all;
>>>>>
>>>>> I have managed to get 2.6.36 to a semi-usable state, but I have major
>>>>> breakage yet.
>>>>>
>>>>> Question: what happens if I simply move my working 2.6.35.7 .config
>>>>> into the 2.6.36 tree and build it from that?
>>>>
>>>> I think that it runs 'make oldconfig' automatically for you.
>>>>
>>>>> It can't be any worse than what the broken 'make oldconfig' did to
>>>>> it. What it output changed the disk drivers, graphic card drivers
>>>>> and just plain threw away at least a hundred lines in the multimedia
>>>>> drivers section.
>>
>> When I use your config-2.6.36.7 file on 2.6.36 and run 'make oldconfig',
> Correction, that config was from 2.6.35.7.
> 
>> I don't see anything like changes in disk or graphics card drivers and
>> I don't see 100 or more lines thrown away in the multimedia drivers.
>>
>> Did you use 'make oldconfig' or did you use that script that you have
>> mentioned and posted in the past?  Could it be causing problems?
> 
> My script (buildit26) takes an old argument and a new argument, that and 
> any patch names needed are edited into it, not passed as arguments, 
> although I have thought of doing that, but as that can lead to typu's 
> getting past these old fingers, I don't trust me doing it with live 
> arguments.  It copy's the old .configs to /tmp long enough to unpack the 
> new, then copy's them into the new tree.  And they do a make oldconfig after 
> any patches have been applied.
> 
> It hasn't been edited since I ran it, so I'll attach it.  Maybe you can see 
> something I missed.

Hi Gene,

I don't understand the last few lines of buildit26 script:

make oldconfig
make mrproper
make xconfig


'make mrproper' is going to blow away the .config file that was just generated
by 'make oldconfig'.  'make help' in the kernel top-level directory says (for mrproper):

  mrproper        - Remove all generated files + config + various backup files

then 'make xconfig' is basically going to give you a 'make defconfig', so yes,
you would see lots of .config file differences from the previous kernel version.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
