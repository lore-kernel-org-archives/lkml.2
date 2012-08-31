Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2HaNSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 09:18:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33402 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2HaNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 09:18:07 -0400
Message-ID: <5040B98A.8090304@suse.cz>
Date: Fri, 31 Aug 2012 15:18:02 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
        dirk.brandewie@gmail.com, linux-i2c@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        jbaron@redhat.com, ben-linux@fluff.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: i2c-designware-core: KBUILD_MODNAME undeclared [was: Build regressions/improvements
  in v3.6-rc1]
References: <1344072256-13170-1-git-send-email-geert@linux-m68k.org> <502C0022.2020106@suse.cz> <20120831144429.554345d0@endymion.delvare>
In-Reply-To: <20120831144429.554345d0@endymion.delvare>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 02:44 PM, Jean Delvare wrote:
> Hi Jiri, Geert,
> 
> On Wed, 15 Aug 2012 22:01:38 +0200, Jiri Slaby wrote:
>> On 08/04/2012 11:24 AM, Geert Uytterhoeven wrote:
>>> Below is the list of build error/warning regressions/improvements in
>>> v3.6-rc1[1] compared to v3.5[2].
>> ...
>>>   + drivers/i2c/busses/i2c-designware-core.c: error: 'KBUILD_MODNAME' undeclared (first use in this function):
>>
>> This is a real problem we are facing here. It happens on PPC when all
>> I2C_DESIGNWARE_PLATFORM, I2C_DESIGNWARE_PCI and DYNAMIC_DEBUG are set.
>>
>> It's because i2c-designware-core.c is used in two modules
>> (i2c-designware-platform and i2c-designware-pci) and KBUILD_MODNAME is
>> not defined for those because (scripts/Makefile.lib):
>> # $(modname_flags) #defines KBUILD_MODNAME as the name of the module
>> # it will end up in (or would, if it gets compiled in)
>> # Note: Files that end up in two or more modules are compiled
>> #       without the KBUILD_MODNAME definition. The reason is
>> #       that any made-up name would differ in different configs.
>>
>> But DYNAMIC_DEBUG needs KBUILD_MODNAME for dev_dbg used in that source.
>>
>> Any ideas? Why is it not a separate module for example?
> 
> It should be. Axel Lin has posted a patch which does that and it should
> fix your problem:
> https://lkml.org/lkml/2012/6/13/233
> 
> Please test and confirm it does the right thing. I'll push the patch
> upstream if it does.

Yes, it does.

thanks,
-- 
js
suse labs
