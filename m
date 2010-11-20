Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0KTXVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 18:21:23 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:44240 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab0KTXVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 18:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NsIxyuIUEYZeOMQXWa99X5XQfZoTxu9+PFTUE3DOeh1N+Vd2BNnTOAVHJa2gK/e4dx
         jwUDbOeKR+02sYvuDRLZayKIh/nvF6ISeq+pTvuI6qi6gjp86Ve0h3OPzzFHZrOt9Mp8
         Y5BLRFhVRKX9CFH+hc0FLJnr6aImb0Dtuudn8=
Message-ID: <4CE857EE.4090704@gmail.com>
Date: Sat, 20 Nov 2010 15:21:18 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: general protection fault: 0000 [#1] SMP
References: <AANLkTik=d4nOUAd_DZCsJL44NB5OvYmux+b58mqs1PGH@mail.gmail.com> <alpine.LNX.2.00.1011202322050.24071@swampdragon.chaosbits.net> <alpine.LNX.2.00.1011202331090.24071@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1011202331090.24071@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2010 02:32 PM, Jesper Juhl wrote:
> On Sat, 20 Nov 2010, Jesper Juhl wrote:
>
>> On Sat, 20 Nov 2010, Justin Mattock wrote:
>>
>>> Ive seen this before, but could not reproduce for a bisect.. basically
>>> what I remember doing
>>> was building webkit(let sit and compile) passed out, woke up at 5AM
>>> closed the lid on the machine,few hrs later
>>> woke up, went for a run, came back opened the lid and this:
>>>
>>> [43925.668053] general protection fault: 0000 [#1] SMP
>>> [43925.668059] last sysfs file: /sys/devices/platform/applesmc.768/light
>>> [43925.668061] CPU 0
>>> [43925.668063] Modules linked in: firewire_sbp2 radeon sco bnep ttm
>>> drm_kms_helper drm ipt_LOG iptable_nat nf_nat xt_state
>>> nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
>>> iptable_filter ip_tables x_tables ath9k ath9k_common video ath9k_hw
>>> sky2 firewire_ohci battery ac ath evdev joydev button firewire_core
>>> i2c_i801 kvm_intel aes_x86_64 lzo zlib ipcomp xfrm_ipcomp crypto_null
>>> sha256_generic cbc des_generic cast5 blowfish serpent camellia
>>> twofish_generic twofish_x86_64 twofish_common ctr ah4 esp4 authenc
>>> uhci_hcd ehci_hcd hci_uart rfcomm btusb hidp l2cap bluetooth coretemp
>>> acpi_cpufreq processor mperf appletouch applesmc uvcvideo
>>> [43925.668120]
>>> [43925.668123] Pid: 27262, comm: make Not tainted
>>> 2.6.37-rc2-00037-g7957f0a-dirty #6 Mac-F42187C8/MacBookPro2,2
>>> [43925.668126] RIP: 0010:[<ffffffff811bf10a>]  [<ffffffff811bf10a>]
>>> inode_has_perm+0x53/0x6a
>>> [43925.668135] RSP: 0018:ffff88003c5a5bc8  EFLAGS: 00010282
>>> [43925.668137] RAX: ffff88003826a208 RBX: ffff88000008ed80 RCX: ffff88003c5a5c68
>>> [43925.668140] RDX: 0000000000000002 RSI: ffff88000008ed80 RDI: ffff88002feacc00
>>> [43925.668142] RBP: ffff88003c5a5c58 R08: ffff88003c5a5c68 R09: 00000000000000d5
>>> [43925.668145] R10: 050366048b660e04 R11: 0000000000000000 R12: 0000000000000024
>>> [43925.668147] R13: 00000000ffffffd8 R14: 0000000000000000 R15: 0000000000000000
>>> [43925.668150] FS:  00007f4f786b3700(0000) GS:ffff88003ee00000(0000)
>>> knlGS:0000000000000000
>>> [43925.668153] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [43925.668155] CR2: 00007f4f78637000 CR3: 00000000383ac000 CR4: 00000000000006e0
>>> [43925.668158] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [43925.668161] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [43925.668163] Process make (pid: 27262, threadinfo ffff88003c5a4000,
>>> task ffff880001afb410)
>>> [43925.668165] Stack:
>>> [43925.668167]  ffff880038a98060 0000000000000000 ffff88003c5a5c48
>>> ffffffff81182b7c
>>> [43925.668172]  ffff88003cab2688 ffff880024da9990 ffff88003caa18d8
>>> ffff880038a98060
>>> [43925.668177]  ffff880024da98b0 ffffea0000a54940 ffff88003c5a5c78
>>> ffff88003d402500
>>> [43925.668182] Call Trace:
>>> [43925.668189]  [<ffffffff81182b7c>] ? jbd2_journal_stop+0x21e/0x230
>>> [43925.668193]  [<ffffffff811be4bb>] ? selinux_cred_free+0xb/0x27
>>> [43925.668196]  [<ffffffff811be441>] ? selinux_file_alloc_security+0x4a/0xb9
>>> [43925.668201]  [<ffffffff810f4226>] ? check_object+0x13b/0x1eb
>>> [43925.668205]  [<ffffffff811bf853>] selinux_inode_permission+0xd2/0xd4
>>> [43925.668211]  [<ffffffff811bbf9c>] security_inode_permission+0x1c/0x1e
>>> [43925.668215]  [<ffffffff81101ab2>] inode_permission+0x87/0x93
>>> [43925.668218]  [<ffffffff81102e86>] may_open+0x9e/0x11e
>>> [43925.668221]  [<ffffffff8110373e>] do_last+0x542/0x6fa
>>> [43925.668225]  [<ffffffff811056ec>] do_filp_open+0x1f3/0x646
>>> [43925.668228]  [<ffffffff810f4226>] ? check_object+0x13b/0x1eb
>>> [43925.668232]  [<ffffffff81103958>] ? getname+0x2c/0x1be
>>> [43925.668236]  [<ffffffff8110eca8>] ? alloc_fd+0x111/0x123
>>> [43925.668240]  [<ffffffff810f7a84>] do_sys_open+0x5b/0xf8
>>> [43925.668243]  [<ffffffff810f7b4a>] sys_open+0x1b/0x1d
>>> [43925.668248]  [<ffffffff8102b542>] system_call_fastpath+0x16/0x1b
>>> [43925.668250] Code: 02 00 00 44 8b 48 04 48 85 c9 75 1f 4c 8d 85 70
>>> ff ff ff b9 22 00 00 00 4c 89 c7 44 89 d8 f3 ab c6 85 70 ff ff ff 01
>>> 48 89 75 90<41>  0f b7 42 20 89 d1 41 8b 72 1c 89 c2 44 89 cf e8 99 e7
>>> ff ff
>>> [43925.668288] RIP  [<ffffffff811bf10a>] inode_has_perm+0x53/0x6a
>>> [43925.668291]  RSP<ffff88003c5a5bc8>
>>> [43925.668295] ---[ end trace 75bdddc506717838 ]---
>>> [43934.866252] general protection fault: 0000 [#2] SMP
>>> [43934.866257] last sysfs file: /sys/devices/platform/applesmc.768/light
>>> [43934.866260] CPU 0
>>> [43934.866261] Modules linked in: firewire_sbp2 radeon sco bnep ttm
>>> drm_kms_helper drm ipt_LOG iptable_nat nf_nat xt_state
>>> nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4
>>> iptable_filter ip_tables x_tables ath9k ath9k_common video ath9k_hw
>>> sky2 firewire_ohci battery ac ath evdev joydev button firewire_core
>>> i2c_i801 kvm_intel aes_x86_64 lzo zlib ipcomp xfrm_ipcomp crypto_null
>>> sha256_generic cbc des_generic cast5 blowfish serpent camellia
>>> twofish_generic twofish_x86_64 twofish_common ctr ah4 esp4 authenc
>>> uhci_hcd ehci_hcd hci_uart rfcomm btusb hidp l2cap bluetooth coretemp
>>> acpi_cpufreq processor mperf appletouch applesmc uvcvideo
>>> [43934.866318]
>>> [43934.866321] Pid: 27283, comm: make Tainted: G      D
>>> 2.6.37-rc2-00037-g7957f0a-dirty #6 Mac-F42187C8/MacBookPro2,2
>>> [43934.866324] RIP: 0010:[<ffffffff811bf10a>]  [<ffffffff811bf10a>]
>>> inode_has_perm+0x53/0x6a
>>> [43934.866334] RSP: 0018:ffff88003c5a5bc8  EFLAGS: 00010282
>>> [43934.866336] RAX: ffff88003807a958 RBX: ffff88000008ed80 RCX: ffff88003c5a5c68
>>> [43934.866339] RDX: 0000000000000002 RSI: ffff88000008ed80 RDI: ffff880034b01700
>>> [43934.866341] RBP: ffff88003c5a5c58 R08: ffff88003c5a5c68 R09: 00000000000000d5
>>> [43934.866343] R10: 050366048b660e04 R11: 0000000000000000 R12: 0000000000000024
>>> [43934.866346] R13: 00000000ffffffd8 R14: 0000000000000000 R15: 0000000000000000
>>> [43934.866349] FS:  00007fdf0a661700(0000) GS:ffff88003ee00000(0000)
>>> knlGS:0000000000000000
>>> [43934.866352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [43934.866354] CR2: 00007fdf0a5e5000 CR3: 0000000029800000 CR4: 00000000000006e0
>>> [43934.866357] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [43934.866359] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [43934.866362] Process make (pid: 27283, threadinfo ffff88003c5a4000,
>>> task ffff880001afb410)
>>> [43934.866364] Stack:
>>> [43934.866366]  ffff88002f398a50 ffff880024da9990 000000003c5a5c78
>>> ffffffff81810be8
>>> [43934.866371]  0020000000000001 0000000000000001 0000000000001000
>>> ffff880037bc0a00
>>> [43934.866375]  0000000000001000 ffffea0000a54940 ffff88003c5a5d18
>>> ffff88003d402500
>>> [43934.866380] Call Trace:
>>> [43934.866385]  [<ffffffff811be4bb>] ? selinux_cred_free+0xb/0x27
>>> [43934.866389]  [<ffffffff811be441>] ? selinux_file_alloc_security+0x4a/0xb9
>>> [43934.866395]  [<ffffffff810f4226>] ? check_object+0x13b/0x1eb
>>> [43934.866398]  [<ffffffff811bf853>] selinux_inode_permission+0xd2/0xd4
>>> [43934.866404]  [<ffffffff811bbf9c>] security_inode_permission+0x1c/0x1e
>>> [43934.866409]  [<ffffffff81101ab2>] inode_permission+0x87/0x93
>>> [43934.866412]  [<ffffffff81102e86>] may_open+0x9e/0x11e
>>> [43934.866415]  [<ffffffff8110373e>] do_last+0x542/0x6fa
>>> [43934.866419]  [<ffffffff811056ec>] do_filp_open+0x1f3/0x646
>>> [43934.866422]  [<ffffffff810f4226>] ? check_object+0x13b/0x1eb
>>> [43934.866426]  [<ffffffff81103958>] ? getname+0x2c/0x1be
>>> [43934.866430]  [<ffffffff8110eca8>] ? alloc_fd+0x111/0x123
>>> [43934.866433]  [<ffffffff810f7a84>] do_sys_open+0x5b/0xf8
>>> [43934.866437]  [<ffffffff810f7b4a>] sys_open+0x1b/0x1d
>>> [43934.866441]  [<ffffffff8102b542>] system_call_fastpath+0x16/0x1b
>>> [43934.866443] Code: 02 00 00 44 8b 48 04 48 85 c9 75 1f 4c 8d 85 70
>>> ff ff ff b9 22 00 00 00 4c 89 c7 44 89 d8 f3 ab c6 85 70 ff ff ff 01
>>> 48 89 75 90<41>  0f b7 42 20 89 d1 41 8b 72 1c 89 c2 44 89 cf e8 99 e7
>>> ff ff
>>> [43934.866481] RIP  [<ffffffff811bf10a>] inode_has_perm+0x53/0x6a
>>> [43934.866484]  RSP<ffff88003c5a5bc8>
>>> [43934.866488] ---[ end trace 75bdddc506717839 ]---
>>>
>> [...]
>>
>> Hmm, ok, I have no idea about the root cause of this problem, but I did
>> notice one thing about selinux_cred_free() that's different than most
>> other freeing functions in the kernel. It does not accept a NULL value.
>> Most other freeing functions will just return if passed NULL, but
>> selinux_cred_free() will crash.
>> I wonder if it would make sense to add a NULL 'short circuit' to that
>> function? If so, please pick up the patch below.
>>
>>
>> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
>> ---
>>   hooks.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
>> index 65fa8bf..d088532 100644
>> --- a/security/selinux/hooks.c
>> +++ b/security/selinux/hooks.c
>> @@ -3193,11 +3193,11 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
>>    */
>>   static void selinux_cred_free(struct cred *cred)
>>   {
>> -	struct task_security_struct *tsec = cred->security;
>> -
>> +	if (!cred)
>> +		return;
>>   	BUG_ON((unsigned long) cred->security<  PAGE_SIZE);
>>   	cred->security = (void *) 0x7UL;
>> -	kfree(tsec);
>> +	kfree(cred->security);
>>   }
>>
>>   /*
>>
>
> Arrgh, sent the wrong (early version) patch. This is what it should have
> been:
>
>
> Signed-off-by: Jesper Juhl<jj@chaosbits.net>
> ---
>   hooks.c |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 65fa8bf..00f28dc 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3193,9 +3193,12 @@ static int selinux_cred_alloc_blank(struct cred *cred, gfp_t gfp)
>    */
>   static void selinux_cred_free(struct cred *cred)
>   {
> -	struct task_security_struct *tsec = cred->security;
> +	struct task_security_struct *tsec;
>
> +	if (!cred)
> +		return;
>   	BUG_ON((unsigned long) cred->security<  PAGE_SIZE);
> +	tsec = cred->security;
>   	cred->security = (void *) 0x7UL;
>   	kfree(tsec);
>   }
>
>
>


sure.. I'll load this patch in.. I will post if I see anything out of 
the ordinary.

Justin P. Mattock
