Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0CWO3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:29:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0CWO3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:29:36 -0400
Message-ID: <4BA8D048.3030407@suse.de>
Date: Tue, 23 Mar 2010 19:59:28 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jeff Layton <jlayton@samba.org>
Cc: Gene Heskett <gene.heskett@verizon.net>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] shutdown bugs, since about 2.6.31 or so
References: <201003222050.55716.gene.heskett@verizon.net>	<4BA843C5.9080307@suse.de> <20100323064351.2135192b@corrin.poochiereds.net>
In-Reply-To: <20100323064351.2135192b@corrin.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 04:13 PM, Jeff Layton wrote:
> On Tue, 23 Mar 2010 09:59:57 +0530
>>
>> On 03/23/2010 06:20 AM, Gene Heskett wrote:
>>> Greetings;
>>>
>>> I do not know if I am miss-configured or what, and I hadn't worried about it 
>>> extensively because the machine runs fine ANAICT.
>>>
>>> But any reboot method short of just pressing the hdwe reset button generates 
>>> quite a lengthy process of repeatedly pressing ctl-alt-del, minimum of 6 
>>> times I believe, in order to actually do a shutdown, and this isn't at all 
>>> graceful.  Not all of it makes it to the log, but here is what does.
>>>
>>> Mar 22 16:47:53 coyote kernel: [ 3000.619173] BUG: Dentry d76beaa0{i=2,n=/} 
>>> still in use (1) [unmount of cifs cifs]
>>> Mar 22 16:47:53 coyote kernel: [ 3000.619191] ------------[ cut here 
>>> ]------------
>>> Mar 22 16:47:53 coyote kernel: [ 3000.619303] kernel BUG at fs/dcache.c:676!
>>> Mar 22 16:47:53 coyote kernel: [ 3000.619420] invalid opcode: 0000 [#1] 
>>> PREEMPT SMP

Is your server an OS/2 server by any chance?

>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Pid: 5747, comm: umount.cifs 
>>> Not tainted 2.6.34-rc2 #1 M2N-SLI DELUXE/System Product Name
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EIP: 0060:[<c10946ae>] EFLAGS: 
>>> 00010246 CPU: 1
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EIP is at 
>>> shrink_dcache_for_umount_subtree+0x14b/0x1fe
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EAX: 0000005b EBX: 00000001 
>>> ECX: 00000046 EDX: 00000000
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] ESI: d76beaa0 EDI: d76beafc 
>>> EBP: d55e6f24 ESP: d55e6ef4
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  DS: 007b ES: 007b FS: 00d8 GS: 
>>> 00e0 SS: 0068
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Process umount.cifs (pid: 5747, 
>>> ti=d55e6000 task=d55d8780 task.ti=d55e6000)
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Stack:
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  c12d20ac d76beaa0 00000002 
>>> d76beafc 00000001 fa14da01 dc956b64 fa14da01
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] <0> 0000001b dc956a00 fa14a7b4 
>>> dc956a00 d55e6f30 c109478e dc956a00 d55e6f40
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] <0> c1087d38 00000013 fa158a5c 
>>> d55e6f4c c1087e32 dc956a00 d55e6f5c c10883c6
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Call Trace:
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c109478e>] ? 
>>> shrink_dcache_for_umount+0x2d/0x37
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1087d38>] ? 
>>> generic_shutdown_super+0x15/0xd2
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1087e32>] ? 
>>> kill_anon_super+0xc/0x43
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c10883c6>] ? 
>>> deactivate_super+0x39/0x4b
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1098dfd>] ? 
>>> mntput_no_expire+0x8c/0xbb
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c10992df>] ? 
>>> sys_umount+0x299/0x2be
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117]  [<c1002813>] ? 
>>> sysenter_do_call+0x12/0x22
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] Code: 00 89 45 ec 8b 46 10 8b 
>>> 1e 8b 7e 28 85 c0 74 03 8b 50 20 8d 81 64 01 00 00 50 ff 75 ec 53 57 52 56 6
>>> 8 ac 20 2d c1 e8 b5 fc 1b 00 <0f> 0b 83 c4 1c eb fe 8b 7e 1c 39 fe 75 04 31 
>>> ff eb 03 f0 ff 0f
>>> Mar 22 16:47:53 coyote kernel: [ 3000.620117] EIP: [<c10946ae>] 
>>> shrink_dcache_for_umount_subtree+0x14b/0x1fe SS:ESP 0068:d55e6ef4
>>> Mar 22 16:47:53 coyote kernel: [ 3000.627952] ---[ end trace fbecccbb5fac2d05 
>>> ]

> 
> Looks like the same bug as reported here:
> 
> http://lists.samba.org/archive/linux-cifs-client/2010-February/005560.html
> 
> ...the patch I asked them to test is now here:
> 
> http://git.samba.org/?p=jlayton/linux.git;a=commit;h=fd0ab22278f38b0e2b7d303a1101b15d3255aee9
> 
> ...but I still think the problem is likely in how we autodisable server
> inode numbers.

Yes, I also suspect a problem with autodisabling server inode numbers
esp against OS/2 servers, but I never got around a box or reproduce to
investigate it myself.

Thanks,

-- 
Suresh Jayaraman
