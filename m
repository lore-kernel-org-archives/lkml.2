Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab0LTXqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:46:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:56785 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933293Ab0LTXqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:46:15 -0500
Message-ID: <4D0FEAC4.8020009@suse.cz>
Date: Tue, 21 Dec 2010 00:46:12 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Build regression: unknown option "visible"
References: <20101220172228.GA463@Pilar.aei.mpg.de> <AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
In-Reply-To: <AANLkTi=3WHB6iKaM5-=z33b9Nux7WyQ2K0apuRNwMhD=@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.2010 18:37, Arnaud Lacombe wrote:
> Hi,
>
> On Mon, Dec 20, 2010 at 12:22 PM, Carlos R. Mafra<crmafra2@gmail.com>  wrote:
>> After pulling latest git from Linus (v2.6.37-rc6-132-g55ec86f)
>> I can't compile it anymore:
>>
>> [mafra@Pilar:linux-2.6]$ make -j2 O=/mnt/ext4/kernel-output/
>>   GEN     /mnt/ext4/kernel-output/Makefile
>> scripts/kconfig/conf --silentoldconfig Kconfig
>> drivers/i2c/algos/Kconfig:6: unknown option "visible"
>> drivers/media/common/tuners/Kconfig:48: unknown option "visible"
>> drivers/media/video/Kconfig:115: unknown option "visible"
>> drivers/media/dvb/frontends/Kconfig:16: unknown option "visible"
>> make[3]: *** [silentoldconfig] Fehler 1
>> make[2]: *** [silentoldconfig] Fehler 2
>>
>> This was introduced by 37e3273ee52f ("media/video: convert Kconfig
>> to use the menu's `visible' keyword"), but I did a quick search
>> and apparently I am the only one with a broken build.
>>
>> In any case, that's a regression for me and therefore I'm reporting it.
>>
>> I can test patches etc and provide more info if needed.
>>
> Did you build from a clean tree or a dirty one ?
>
> I know these is issue with Kbuild where the parser will not get
> updated to the new version if the target already exist but is older
> than the current "shipped" one.

Yes, if you build kconfig in the source tree and then do another build 
in a separate directory (make O=/some/where), the build system will not 
detect this and happily use generated kconfig files from the previous 
build attempt. I really should fix this given the pace of kconfig 
development lately :-).

Michal
