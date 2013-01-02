Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3ABQoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:44:30 -0500
Received: from nm26-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.225]:40694
	"EHLO nm26-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752991Ab3ABQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:44:26 -0500
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2013 11:44:26 EST
X-Yahoo-Newman-Id: 470458.98386.bm@smtp106.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LRwiUxEVM1mGhIYsFwkxexhWMo7BQHJBoDP6wC6O3BayWVT
 m7.0k22o6YKn9mBnHVlmprvJPJ.9jtSwTZYt6PMsQ5wNnSlbeyrdr801xdng
 sbBbXOER.5U_uZrnEcI5XQ9FRywXX1i.WNh9v8n_GBWodrcI22yKh8w.x1eD
 cn8zl_NJ.6pfvkt6hqQMPsViyzK9FJg1W2JLUigc.VmhFjHTN1gsamBBLIlL
 r7takYDpvmldLx0pJlCYO.D3WPyDcBdWV1jRQtd.Uj6Iz9JL.E6uc9jGlBZd
 UAWfLHRng_UKQj.OoSeUA14fbCquk.mlMNtIoBq8bgpul4MLDIdOXgnc9R0x
 OMPZ4iYpunEsyJEyvSPOdeBzOFskGcKgkI3cn4_f.vdiI1JbLWdKB6gAzcID
 i2btHuZUMFNkH_sPVfvuiCV.2HoNMlHb65ukwUJrS33N9ZiqfdPUCkbJ1yz0
 kfKzPj_FvFvoNmwoH7mfIhw31sdTJlR2z.JzgI3qbwOxHDnmhT5trpYHnoV7
 66o4h5_F5w03kHTvAB_wnYA--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50E46262.1050906@schaufler-ca.com>
Date: Wed, 02 Jan 2013 08:37:54 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, SE Linux <selinux@tycho.nsa.gov>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: order 4 alloc failures in security_context_to_sid_core
References: <20130102153501.GB25940@redhat.com>
In-Reply-To: <20130102153501.GB25940@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/2/2013 7:35 AM, Dave Jones wrote:
> Along the same lines as 779302e67835fe9a6b74327e54969ba59cb3478a, xattrs
> can cause big allocations, which are likely to fail under memory pressure..

Adding LSM and SELinux lists.

> [20539.081122] trinity-child3: page allocation failure: order:4, mode:0x1040d0
> [20539.090405] Pid: 27617, comm: trinity-child3 Not tainted 3.8.0-rc1+ #43
> [20539.097883] Call Trace:
> [20539.105032]  [<ffffffff8113c2ac>] warn_alloc_failed+0xec/0x140
> [20539.112549]  [<ffffffff810b882d>] ? trace_hardirqs_on+0xd/0x10
> [20539.119609]  [<ffffffff810c02a0>] ? on_each_cpu_mask+0x70/0xd0
> [20539.127089]  [<ffffffff81140c2e>] __alloc_pages_nodemask+0x91e/0xba0
> [20539.134380]  [<ffffffff81182318>] alloc_pages_current+0xb8/0x180
> [20539.141803]  [<ffffffff8113b20a>] __get_free_pages+0x2a/0x80
> [20539.149513]  [<ffffffff8118ee1e>] kmalloc_order_trace+0x3e/0x1a0
> [20539.157553]  [<ffffffff8100a186>] ? native_sched_clock+0x26/0x90
> [20539.164898]  [<ffffffff8118f275>] __kmalloc+0x2f5/0x3a0
> [20539.172288]  [<ffffffff812db176>] security_context_to_sid_core+0x86/0x280
> [20539.179909]  [<ffffffff813318a8>] ? __const_udelay+0x28/0x30
> [20539.187356]  [<ffffffff812c4118>] ? avc_has_perm_flags+0x178/0x2b0
> [20539.194911]  [<ffffffff812c3fc9>] ? avc_has_perm_flags+0x29/0x2b0
> [20539.202883]  [<ffffffff810b2342>] ? get_lock_stats+0x22/0x70
> [20539.211117]  [<ffffffff812dc6d9>] security_context_to_sid+0x19/0x20
> [20539.218729]  [<ffffffff812c76f0>] selinux_inode_setxattr+0xf0/0x220
> [20539.226502]  [<ffffffff811d42f1>] ? vfs_setxattr+0x71/0xc0
> [20539.233517]  [<ffffffff811d42f1>] ? vfs_setxattr+0x71/0xc0
> [20539.240734]  [<ffffffff812c18d0>] security_inode_setxattr+0x20/0x30
> [20539.248184]  [<ffffffff811d4306>] vfs_setxattr+0x86/0xc0
> [20539.255357]  [<ffffffff811d446e>] setxattr+0x12e/0x1d0
> [20539.262691]  [<ffffffff813426b5>] ? __percpu_counter_add+0x75/0xc0
> [20539.270289]  [<ffffffff811aed33>] ? __sb_start_write+0x103/0x1c0
> [20539.277927]  [<ffffffff811cf6a8>] ? mnt_want_write_file+0x28/0x60
> [20539.285396]  [<ffffffff8104cc74>] ? do_setitimer+0x1c4/0x300
> [20539.292986]  [<ffffffff811cf6a8>] ? mnt_want_write_file+0x28/0x60
> [20539.300219]  [<ffffffff811cf592>] ? __mnt_want_write+0x62/0xa0
> [20539.307259]  [<ffffffff811d491e>] sys_fsetxattr+0xbe/0xf0
> [20539.314184]  [<ffffffff816a4a82>] system_call_fastpath+0x16/0x1b
>
>
> 	Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

