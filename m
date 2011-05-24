Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab1EXNXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:23:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:45976 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110Ab1EXNX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:23:29 -0400
Message-ID: <4DDBB150.2090602@suse.cz>
Date: Tue, 24 May 2011 15:23:28 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Hiromu Yakura <hiromu1996@gmail.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: [PATCH] Kconfig: add warning about permission of config file
References: <1306167401.18840.8.camel@hiromu-MacBook>	 <BANLkTikhFdd_PRzCg3w9HD1TO=cmdmm6_A@mail.gmail.com> <1306242400.7501.10.camel@hiromu-MacBook>
In-Reply-To: <1306242400.7501.10.camel@hiromu-MacBook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.5.2011 15:06, Hiromu Yakura wrote:
> Hello,
> thanks for replying.
>
> On Mon, May 23, 2011 at 13:58, Arnaud Lacombe<lacombar@gmail.com>  wrote:
>> Do you have a precise way to reproduce this, in particular which
>> target is involved ? I tried to `chmod 555' the kernel root directory,
>> re-ran `conf' (through the `defconfig' target) and `mconf' (manually
>> for this one, as check-lxdialog.sh fails when invoked though make).
>> The former failed with:
>>
>> *** Error during writing of the configuration.
>>
>> gmake[1]: *** [defconfig] Error 1
>> gmake: *** [defconfig] Error 2
> In my environment, this patch is working properly.
> The output is as follows:
>
> hiromu@hiromu-MacBook:/usr/src/linux-2.6$ ls -ld .
> dr-xr-sr-x 25 hiromu hiromu 4096 May 24 21:41 .
> hiromu@hiromu-MacBook:/usr/src/linux-2.6$ make defconfig
> *** Default configuration is based on 'x86_64_defconfig'
> *** Permission denied to write the configuration.

Arnaud's point is that your patch should not be necessary at all, 
because kconfig already checks the return value of the fopen() call in 
conf_write() and prints the above message if it fails. So do you have a 
testcase where make <...>config without your patch returns without 
error, but the configuration is not written?

Michal
