Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab1KPCNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:13:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:42334 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1KPCNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:13:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org
References: <20111113192417.GA1659@x4.trippels.de>
	<20111116003949.GA15882@suse.de>
Date: Tue, 15 Nov 2011 18:14:34 -0800
In-Reply-To: <20111116003949.GA15882@suse.de> (Greg KH's message of "Tue, 15
	Nov 2011 16:39:49 -0800")
Message-ID: <m1fwhoolth.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/U0dqGC9h726Z67HXDKpDIo5gWF2zwzSc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@suse.de>
X-Spam-Relay-Country: **
Subject: Re: WARNING: at fs/sysfs/sysfs.h:195 (during boot)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Sun, Nov 13, 2011 at 08:24:17PM +0100, Markus Trippelsdorf wrote:
>> I'm seeing this for the fist time:
>> 
>> ...
>> XFS (sda): Mounting Filesystem
>> XFS (sda): Ending clean mount
>> ATL1E 0000:02:00.0: irq 40 for MSI/MSI-X
>> ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
>> ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
>> udevd[888]: starting version 171
>> ------------[ cut here ]------------
>> WARNING: at fs/sysfs/sysfs.h:195 sysfs_get_inode+0x136/0x140()
>> Hardware name: System Product Name
>> Pid: 945, comm: udevadm Not tainted 3.2.0-rc1-00252-g8f042aa #49
>> Call Trace:
>>  [<ffffffff81072795>] warn_slowpath_common+0x75/0xb0
>>  [<ffffffff81072895>] warn_slowpath_null+0x15/0x20
>>  [<ffffffff81167b26>] sysfs_get_inode+0x136/0x140
>>  [<ffffffff811695df>] sysfs_lookup+0x6f/0x110
>>  [<ffffffff8111b739>] d_alloc_and_lookup+0x39/0x80
>>  [<ffffffff8111ca93>] do_lookup+0x283/0x390
>>  [<ffffffff8111d954>] path_lookupat+0x114/0x6d0
>>  [<ffffffff8111b946>] ? getname_flags+0x36/0x230
>>  [<ffffffff8111df3b>] do_path_lookup+0x2b/0x70
>>  [<ffffffff8111e3a8>] user_path_at_empty+0x58/0xb0
>>  [<ffffffff81169d4c>] ? sysfs_put_link+0x1c/0x20
>>  [<ffffffff81120ac4>] ? generic_readlink+0x84/0xa0
>>  [<ffffffff8111e40c>] user_path_at+0xc/0x10
>>  [<ffffffff811161e0>] vfs_fstatat+0x30/0x70
>>  [<ffffffff8112d94b>] ? mntput_no_expire+0x2b/0xe0
>>  [<ffffffff81116236>] vfs_stat+0x16/0x20
>>  [<ffffffff81116305>] sys_newstat+0x15/0x30
>>  [<ffffffff8111642e>] ? sys_readlinkat+0x7e/0xb0
>>  [<ffffffff814d2c7b>] system_call_fastpath+0x16/0x1b
>> ---[ end trace 2226f614d7765573 ]---
>> Adding 2097148k swap on /var/tmp/swap/swapfile.  Priority:-1 extents:2 across:2634672k
>> 
>> fs/sysfs/sysfs.h:195: 
>>     WARN_ON(!atomic_read(&sd->s_count));
>
> Odd, is it reproducable?
>
> Eric, any ideas?

So this indicates we found a sysfs_dirent in a directory with a
reference count of 0.

If this isn't caused by a bitflip.  My guess would be something off in
the new sysfs directory handling.

Off the top of my head I don't know how the new sysfs directory
handling could have caused this.  But I expect it would take
a fair amount of directory modification to cause this.  Everything
is serialized under the sysfs_mutex so it should be really hard
to trigger race conditions.  I am scratching my head.

Eric
