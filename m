Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1KHIZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:25:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1KHIZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:25:04 -0500
Message-ID: <4EB8E75D.1010706@suse.cz>
Date: Tue, 08 Nov 2011 09:25:01 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] Kbuild: append missing-syscalls to the default target
 list
References: <1314234210-11090-1-git-send-email-lacombar@gmail.com> <4E69FEC9.2080204@suse.cz> <CACqU3MUFyn_jh2pN4GLENqcGVUzAwcMJUR_WLY2EtqOhMheceQ@mail.gmail.com> <20111101232233.GA32441@sepie.suse.cz> <20111107204448.GA9949@linux-mips.org> <20111107211900.GB6264@sepie.suse.cz> <20111107233330.GA26705@linux-mips.org>
In-Reply-To: <20111107233330.GA26705@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.11.2011 00:33, Ralf Baechle wrote:
> On Mon, Nov 07, 2011 at 10:19:00PM +0100, Michal Marek wrote:
> 
>> Wild guess - does this patch help?
>>
>>
>> diff --git a/Kbuild b/Kbuild
>> index 4caab4f..77c191a 100644
>> --- a/Kbuild
>> +++ b/Kbuild
>> @@ -94,7 +94,7 @@ targets += missing-syscalls
>>  quiet_cmd_syscalls = CALL    $<
>>        cmd_syscalls = $(CONFIG_SHELL) $< $(CC) $(c_flags)
>>  
>> -missing-syscalls: scripts/checksyscalls.sh $(offsets-file) FORCE
>> +missing-syscalls: scripts/checksyscalls.sh $(offsets-file) $(bounds-file) FORCE
>>  	$(call cmd,syscalls)
>>  
>>  # Keep these two files during make clean
> 
> No, it didn't.
> 
>> If not, please attach logs of make V=1 with clean Linus' tree and with
>> 5f7efb4c6da9f90cb306923ced2a6494d065a595 reverted.
> 
> $ git checkout 31555213f03bca37d2c02e10946296052f4ecfcd
> $ git revert 5f7efb4c6da9f90cb306923ced2a6494d065a595
> $ make ARCH=mips ip27_defconfig
> $ make ARCH=mips V=1 2>&1 | tee log

Thanks, can you also post a log without the revert?

Michal
