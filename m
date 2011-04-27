Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012Ab1D0MfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 08:35:04 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46711 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab1D0MfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 08:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:date:in-reply-to:references:content-type
         :x-mailer:content-transfer-encoding:message-id:mime-version;
        b=i27FqMBJpAbwTbDmnvIMSglvUHBhk0XOZGg4Jl1F8i0rIYxTz04PgNc99v9LPvZGWI
         BbfeN55O3Qd62hn7rTNxIZwJnPe/PKnHA6vpOfrgLNaM7zzETmza+6C6BTT22IPkFC2X
         e6LhCdHG0C6sLl8QhSzBxJ6vhBKY0i6VpRg30=
Subject: Re: Reiserfs deadlock in 2.6.36
From: "solsTiCe d'Hiver" <solstice.dhiver@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jeff Mahoney <jeffm@suse.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 27 Apr 2011 14:34:49 +0200
In-Reply-To: <BANLkTinSNhdGU0pcCERCUeQA-Ba2VZHNeg@mail.gmail.com>
References: <201103311704.40372.roucaries.bastien@gmail.com>
	 <BANLkTikmtyyMes84rED5wpMxuN8kL91jEw@mail.gmail.com>
	 <4D9B3C10.9060704@suse.com>
	 <BANLkTi=XDzOcZsP+aKS_WQSRxT+N8XHBRQ@mail.gmail.com>
	 <BANLkTi=yTfMiLvVtZTqQvxVhy7aFPdwSXQ@mail.gmail.com>
	 <BANLkTi=KUMNWJZZBQSHK+WViy6BYv8+4dQ@mail.gmail.com>
	 <BANLkTi=LHx-cwQ8dAY7ogLN0B5xtJApVWg@mail.gmail.com>
	 <20110411231843.GB2061@nowhere>
	 <BANLkTinHk7fVi62_Xftwn_0WLOzkS4jggw@mail.gmail.com>
	 <BANLkTikjD9hRPagnvjYO7A3ESGrwd1Qe-Q@mail.gmail.com>
	 <20110426152908.GA2879@nowhere>
	 <BANLkTimdaH5=q8M1bLCUTQ8aXJp4N1Dvyw@mail.gmail.com>
	 <BANLkTinSNhdGU0pcCERCUeQA-Ba2VZHNeg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 
Content-Transfer-Encoding: 8bit
Message-ID: <1303907695.15897.11.camel@soho.example.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 13:10 +0200, Bastien ROUCARIES a écrit :
> Seems also that  <solstice.dhiver@gmail.com> is hitting the same bug...
> 
I don't know if it's the same bug because I never had problem with
kernel before 2.6.38.2. I have the problem with 2.6.38.3 too
but it never happened with 2.6.36 or 2.6.37 archlinux default kernel

I have downgraded to 2.6.37.5 and I have no problem so far.

/home (reseirfs fs) is mounted with defaults,nodev,relatime,user_xattr
options

My latest call trace with 2.6.38.3 with default archlinux configuration
of the kernel
http://paste.pocoo.org/show/378982/ or below:
Apr 25 13:14:25 soho -- MARK --
Apr 25 13:32:04 soho kernel: [ 9480.565812] conky           D f427b588
0  6930   6832 0x00000000
Apr 25 13:32:04 soho kernel: [ 9480.565823]  f1d47ce8 00200086 00000001
f427b588 f427b5cc f4404a00 f427b580 f1d47cf3
Apr 25 13:32:04 soho kernel: [ 9480.565837]  0000000b f1d47cb4 f4257600
0002bd1a f4257600 f5806380 c14c0380 f286ccf0
Apr 25 13:32:04 soho kernel: [ 9480.565848]  f286ceb4 e451b7b3 0000087b
c14c0380 f5806380 f286ccf0 f1ef08a0 f1d47cb4
Apr 25 13:32:04 soho kernel: [ 9480.565860] Call Trace:
Apr 25 13:32:04 soho kernel: [ 9480.565877]  [<c1118076>] ? dput
+0xe6/0x160
Apr 25 13:32:04 soho kernel: [ 9480.565923]  [<faaae2fd>]
queue_log_writer+0x6d/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.565938]  [<c103e500>] ?
default_wake_function+0x0/0x10
Apr 25 13:32:04 soho kernel: [ 9480.565956]  [<faab3739>]
do_journal_begin_r+0x1e9/0x360 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.565972]  [<faab6893>] ?
reiserfs_xattr_get+0x33/0x250 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.565982]  [<c1318fbb>] ?
__mutex_lock_slowpath+0x1eb/0x2b0
Apr 25 13:32:04 soho kernel: [ 9480.565995]  [<faab3930>] journal_begin
+0x80/0x160 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566002]  [<c131908b>] ? mutex_lock
+0xb/0x20
Apr 25 13:32:04 soho kernel: [ 9480.566015]  [<faaa23fe>]
reiserfs_dirty_inode+0x2e/0xb0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566029]  [<faab6b2c>] ?
reiserfs_getxattr+0x7c/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566043]  [<faab6ab0>] ?
reiserfs_getxattr+0x0/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566053]  [<c116e816>] ?
cap_inode_need_killpriv+0x26/0x40
Apr 25 13:32:04 soho kernel: [ 9480.566062]  [<c1124d49>]
__mark_inode_dirty+0x29/0x1b0
Apr 25 13:32:04 soho kernel: [ 9480.566070]  [<c10be60f>] ?
file_remove_suid+0x1f/0x70
Apr 25 13:32:04 soho kernel: [ 9480.566077]  [<c111d33b>] ?
mnt_clone_write+0xb/0x50
Apr 25 13:32:04 soho kernel: [ 9480.566085]  [<c1119a19>]
file_update_time+0xb9/0x120
Apr 25 13:32:04 soho kernel: [ 9480.566092]  [<c10bff03>]
__generic_file_aio_write+0x223/0x4c0
Apr 25 13:32:04 soho kernel: [ 9480.566099]  [<c110ed6d>] ? do_lookup
+0xdd/0x260
Apr 25 13:32:04 soho kernel: [ 9480.566106]  [<c111de95>] ?
mntput_no_expire+0x25/0xd0
Apr 25 13:32:04 soho kernel: [ 9480.566114]  [<c10c01fe>]
generic_file_aio_write+0x5e/0xd0
Apr 25 13:32:04 soho kernel: [ 9480.566121]  [<c11043c4>] do_sync_write
+0xa4/0xe0
Apr 25 13:32:04 soho kernel: [ 9480.566130]  [<c116f7bf>] ?
security_file_permission+0x1f/0xa0
Apr 25 13:32:04 soho kernel: [ 9480.566142]  [<faa9c8a8>]
reiserfs_file_write+0x68/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566149]  [<c1104b26>] vfs_write
+0x86/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566160]  [<faa9c840>] ?
reiserfs_file_write+0x0/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566167]  [<c110604b>] ? fget_light
+0x6b/0xc0
Apr 25 13:32:04 soho kernel: [ 9480.566173]  [<c1104e08>] sys_write
+0x38/0x70
Apr 25 13:32:04 soho kernel: [ 9480.566181]  [<c10037df>]
sysenter_do_call+0x12/0x28
Apr 25 13:32:04 soho kernel: [ 9480.566197] devilspie       D 00000000
0  6955   6832 0x00000000
Apr 25 13:32:04 soho kernel: [ 9480.566205]  f2be5e4c 00200086 00000041
00000000 ffffffff 00000002 f6447e80 00000001
Apr 25 13:32:04 soho kernel: [ 9480.566217]  00000000 00000000 00000000
00000040 00000000 f5806380 c14c0380 f1d4ccf0
Apr 25 13:32:04 soho kernel: [ 9480.566228]  f1d4ceb4 20b95aed 00000882
c14c0380 f5806380 f1d4ccf0 f1ef08a0 00000001
Apr 25 13:32:04 soho kernel: [ 9480.566239] Call Trace:
Apr 25 13:32:04 soho kernel: [ 9480.566249]  [<c10ff328>] ?
__mem_cgroup_try_charge+0x2d8/0x4e0
Apr 25 13:32:04 soho kernel: [ 9480.566257]  [<c10fd068>] ?
memcg_check_events+0x28/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566265]  [<c1318edd>]
__mutex_lock_slowpath+0x10d/0x2b0
Apr 25 13:32:04 soho kernel: [ 9480.566272]  [<c131908b>] mutex_lock
+0xb/0x20
Apr 25 13:32:04 soho kernel: [ 9480.566278]  [<c10c01eb>]
generic_file_aio_write+0x4b/0xd0
Apr 25 13:32:04 soho kernel: [ 9480.566285]  [<c10c8995>] ?
lru_cache_add_lru+0x25/0x40
Apr 25 13:32:04 soho kernel: [ 9480.566292]  [<c11043c4>] do_sync_write
+0xa4/0xe0
Apr 25 13:32:04 soho kernel: [ 9480.566301]  [<c116f7bf>] ?
security_file_permission+0x1f/0xa0
Apr 25 13:32:04 soho kernel: [ 9480.566308]  [<c1027530>] ?
do_page_fault+0x0/0x430
Apr 25 13:32:04 soho kernel: [ 9480.566320]  [<faa9c8a8>]
reiserfs_file_write+0x68/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566327]  [<c1104b26>] vfs_write
+0x86/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566338]  [<faa9c840>] ?
reiserfs_file_write+0x0/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566345]  [<c1104e08>] sys_write
+0x38/0x70
Apr 25 13:32:04 soho kernel: [ 9480.566352]  [<c10037df>]
sysenter_do_call+0x12/0x28
Apr 25 13:32:04 soho kernel: [ 9480.566370] chromium        D f1ee7cd8
0  7890   7879 0x00000000
Apr 25 13:32:04 soho kernel: [ 9480.566377]  f1ee7ce8 00200086 00000002
f1ee7cd8 f041a94c f080c0f0 f041a900 00000000
Apr 25 13:32:04 soho kernel: [ 9480.566388]  0000000c f1ee7cb4 f4257600
0002bdea f4257600 f5a06380 c14c0380 f1ef2b20
Apr 25 13:32:04 soho kernel: [ 9480.566399]  f1ef2ce4 f4257600 f42d2248
c14c0380 f5a06380 f1ef2b20 f4462f70 f1ee7cb4
Apr 25 13:32:04 soho kernel: [ 9480.566410] Call Trace:
Apr 25 13:32:04 soho kernel: [ 9480.566417]  [<c1118076>] ? dput
+0xe6/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566439]  [<faaae2fd>]
queue_log_writer+0x6d/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566450]  [<c103e500>] ?
default_wake_function+0x0/0x10
Apr 25 13:32:04 soho kernel: [ 9480.566466]  [<faab3739>]
do_journal_begin_r+0x1e9/0x360 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566480]  [<faab6893>] ?
reiserfs_xattr_get+0x33/0x250 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566488]  [<c1318fbb>] ?
__mutex_lock_slowpath+0x1eb/0x2b0
Apr 25 13:32:04 soho kernel: [ 9480.566501]  [<faab3930>] journal_begin
+0x80/0x160 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566508]  [<c131908b>] ? mutex_lock
+0xb/0x20
Apr 25 13:32:04 soho kernel: [ 9480.566520]  [<faaa23fe>]
reiserfs_dirty_inode+0x2e/0xb0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566533]  [<faab6b2c>] ?
reiserfs_getxattr+0x7c/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566547]  [<faab6ab0>] ?
reiserfs_getxattr+0x0/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566554]  [<c116e816>] ?
cap_inode_need_killpriv+0x26/0x40
Apr 25 13:32:04 soho kernel: [ 9480.566563]  [<c1124d49>]
__mark_inode_dirty+0x29/0x1b0
Apr 25 13:32:04 soho kernel: [ 9480.566569]  [<c10be60f>] ?
file_remove_suid+0x1f/0x70
Apr 25 13:32:04 soho kernel: [ 9480.566576]  [<c111d33b>] ?
mnt_clone_write+0xb/0x50
Apr 25 13:32:04 soho kernel: [ 9480.566584]  [<c1119a19>]
file_update_time+0xb9/0x120
Apr 25 13:32:04 soho kernel: [ 9480.566591]  [<c10bff03>]
__generic_file_aio_write+0x223/0x4c0
Apr 25 13:32:04 soho kernel: [ 9480.566600]  [<c102b6a3>] ?
flush_tlb_page+0x53/0xb0
Apr 25 13:32:04 soho kernel: [ 9480.566607]  [<c10c01fe>]
generic_file_aio_write+0x5e/0xd0
Apr 25 13:32:04 soho kernel: [ 9480.566614]  [<c11043c4>] do_sync_write
+0xa4/0xe0
Apr 25 13:32:04 soho kernel: [ 9480.566622]  [<c116f7bf>] ?
security_file_permission+0x1f/0xa0
Apr 25 13:32:04 soho kernel: [ 9480.566629]  [<c1027530>] ?
do_page_fault+0x0/0x430
Apr 25 13:32:04 soho kernel: [ 9480.566641]  [<faa9c8a8>]
reiserfs_file_write+0x68/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566647]  [<c1104b26>] vfs_write
+0x86/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566658]  [<faa9c840>] ?
reiserfs_file_write+0x0/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566665]  [<c110604b>] ? fget_light
+0x6b/0xc0
Apr 25 13:32:04 soho kernel: [ 9480.566671]  [<c1104e08>] sys_write
+0x38/0x70
Apr 25 13:32:04 soho kernel: [ 9480.566678]  [<c10037df>]
sysenter_do_call+0x12/0x28
Apr 25 13:32:04 soho kernel: [ 9480.566692] chromium        D f1e03ce0
0  7892   7879 0x00000000
Apr 25 13:32:04 soho kernel: [ 9480.566699]  f1e03cf0 00200086 00000002
f1e03ce0 f04e3acc 00000000 f04e3a80 00000000
Apr 25 13:32:04 soho kernel: [ 9480.566710]  0000000c f1e03cbc f4257600
0002bd1a f4257600 f5806380 c14c0380 f1ef1e30
Apr 25 13:32:04 soho kernel: [ 9480.566721]  f1ef1ff4 f4257600 f42d2248
c14c0380 f5806380 f1ef1e30 c1429f60 f1e03cbc
Apr 25 13:32:04 soho kernel: [ 9480.566732] Call Trace:
Apr 25 13:32:04 soho kernel: [ 9480.566739]  [<c1118076>] ? dput
+0xe6/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566759]  [<faaae2fd>]
queue_log_writer+0x6d/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566770]  [<c103e500>] ?
default_wake_function+0x0/0x10
Apr 25 13:32:04 soho kernel: [ 9480.566788]  [<faab3739>]
do_journal_begin_r+0x1e9/0x360 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566802]  [<faab6893>] ?
reiserfs_xattr_get+0x33/0x250 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566809]  [<c10bea0a>] ?
find_get_page+0x5a/0xa0
Apr 25 13:32:04 soho kernel: [ 9480.566816]  [<c1318fbb>] ?
__mutex_lock_slowpath+0x1eb/0x2b0
Apr 25 13:32:04 soho kernel: [ 9480.566829]  [<faab3930>] journal_begin
+0x80/0x160 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566836]  [<c131908b>] ? mutex_lock
+0xb/0x20
Apr 25 13:32:04 soho kernel: [ 9480.566848]  [<faaa23fe>]
reiserfs_dirty_inode+0x2e/0xb0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566861]  [<faab6b2c>] ?
reiserfs_getxattr+0x7c/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566875]  [<faab6ab0>] ?
reiserfs_getxattr+0x0/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566882]  [<c116e816>] ?
cap_inode_need_killpriv+0x26/0x40
Apr 25 13:32:04 soho kernel: [ 9480.566890]  [<c1124d49>]
__mark_inode_dirty+0x29/0x1b0
Apr 25 13:32:04 soho kernel: [ 9480.566896]  [<c10be60f>] ?
file_remove_suid+0x1f/0x70
Apr 25 13:32:04 soho kernel: [ 9480.566903]  [<c111d33b>] ?
mnt_clone_write+0xb/0x50
Apr 25 13:32:04 soho kernel: [ 9480.566910]  [<c1119a19>]
file_update_time+0xb9/0x120
Apr 25 13:32:04 soho kernel: [ 9480.566918]  [<c10bff03>]
__generic_file_aio_write+0x223/0x4c0
Apr 25 13:32:04 soho kernel: [ 9480.566927]  [<c10490f3>] ?
current_fs_time+0x13/0x50
Apr 25 13:32:04 soho kernel: [ 9480.566934]  [<c10c01fe>]
generic_file_aio_write+0x5e/0xd0
Apr 25 13:32:04 soho kernel: [ 9480.566941]  [<c11043c4>] do_sync_write
+0xa4/0xe0
Apr 25 13:32:04 soho kernel: [ 9480.566949]  [<c1134d30>] ? fsnotify
+0x190/0x250
Apr 25 13:32:04 soho kernel: [ 9480.566956]  [<c116f7bf>] ?
security_file_permission+0x1f/0xa0
Apr 25 13:32:04 soho kernel: [ 9480.566968]  [<faa9c8a8>]
reiserfs_file_write+0x68/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566975]  [<c1104b26>] vfs_write
+0x86/0x160
Apr 25 13:32:04 soho kernel: [ 9480.566986]  [<faa9c840>] ?
reiserfs_file_write+0x0/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.566993]  [<c110604b>] ? fget_light
+0x6b/0xc0
Apr 25 13:32:04 soho kernel: [ 9480.566999]  [<c1104f23>] sys_pwrite64
+0x63/0x80
Apr 25 13:32:04 soho kernel: [ 9480.567005]  [<c10037df>]
sysenter_do_call+0x12/0x28
Apr 25 13:32:04 soho kernel: [ 9480.567021] chromium        D f0045cd8
0  7987   7879 0x00000000
Apr 25 13:32:04 soho kernel: [ 9480.567028]  f0045ce8 00000086 00000002
f0045cd8 f040ef4c 00000000 f040ef00 00000000
Apr 25 13:32:04 soho kernel: [ 9480.567039]  0000000d f0045cb4 f4257600
0002bf9a f4257600 f5a06380 c14c0380 f0040000
Apr 25 13:32:04 soho kernel: [ 9480.567049]  f00401c4 f4257600 f42d2248
c14c0380 f5a06380 f0040000 f4462f70 f0045cb4
Apr 25 13:32:04 soho kernel: [ 9480.567060] Call Trace:
Apr 25 13:32:04 soho kernel: [ 9480.567068]  [<c1118076>] ? dput
+0xe6/0x160
Apr 25 13:32:04 soho kernel: [ 9480.567088]  [<faaae2fd>]
queue_log_writer+0x6d/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567099]  [<c103e500>] ?
default_wake_function+0x0/0x10
Apr 25 13:32:04 soho kernel: [ 9480.567115]  [<faab3739>]
do_journal_begin_r+0x1e9/0x360 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567129]  [<faab6893>] ?
reiserfs_xattr_get+0x33/0x250 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567137]  [<c1318fbb>] ?
__mutex_lock_slowpath+0x1eb/0x2b0
Apr 25 13:32:04 soho kernel: [ 9480.567150]  [<faab3930>] journal_begin
+0x80/0x160 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567157]  [<c131908b>] ? mutex_lock
+0xb/0x20
Apr 25 13:32:04 soho kernel: [ 9480.567169]  [<faaa23fe>]
reiserfs_dirty_inode+0x2e/0xb0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567182]  [<faab6b2c>] ?
reiserfs_getxattr+0x7c/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567196]  [<faab6ab0>] ?
reiserfs_getxattr+0x0/0xa0 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567203]  [<c116e816>] ?
cap_inode_need_killpriv+0x26/0x40
Apr 25 13:32:04 soho kernel: [ 9480.567211]  [<c1124d49>]
__mark_inode_dirty+0x29/0x1b0
Apr 25 13:32:04 soho kernel: [ 9480.567218]  [<c10be60f>] ?
file_remove_suid+0x1f/0x70
Apr 25 13:32:04 soho kernel: [ 9480.567224]  [<c111d33b>] ?
mnt_clone_write+0xb/0x50
Apr 25 13:32:04 soho kernel: [ 9480.567232]  [<c1119a19>]
file_update_time+0xb9/0x120
Apr 25 13:32:04 soho kernel: [ 9480.567239]  [<c10bff03>]
__generic_file_aio_write+0x223/0x4c0
Apr 25 13:32:04 soho kernel: [ 9480.567247]  [<c11a08c1>] ?
cpumask_any_but+0x21/0x40
Apr 25 13:32:04 soho kernel: [ 9480.567253]  [<c102b690>] ?
flush_tlb_page+0x40/0xb0
Apr 25 13:32:04 soho kernel: [ 9480.567261]  [<c10c01fe>]
generic_file_aio_write+0x5e/0xd0
Apr 25 13:32:04 soho kernel: [ 9480.567268]  [<c11043c4>] do_sync_write
+0xa4/0xe0
Apr 25 13:32:04 soho kernel: [ 9480.567276]  [<c116f7bf>] ?
security_file_permission+0x1f/0xa0
Apr 25 13:32:04 soho kernel: [ 9480.567284]  [<c1318fbb>] ?
__mutex_lock_slowpath+0x1eb/0x2b0
Apr 25 13:32:04 soho kernel: [ 9480.567296]  [<faa9c8a8>]
reiserfs_file_write+0x68/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567302]  [<c1104b26>] vfs_write
+0x86/0x160
Apr 25 13:32:04 soho kernel: [ 9480.567314]  [<faa9c840>] ?
reiserfs_file_write+0x0/0x90 [reiserfs]
Apr 25 13:32:04 soho kernel: [ 9480.567320]  [<c110604b>] ? fget_light
+0x6b/0xc0
Apr 25 13:32:04 soho kernel: [ 9480.567326]  [<c1104e08>] sys_write
+0x38/0x70
Apr 25 13:32:04 soho kernel: [ 9480.567333]  [<c10037df>]
sysenter_do_call+0x12/0x28
Apr 25 13:35:38 soho kernel: [    0.000000] Initializing cgroup subsys
cpuset
Apr 25 13:35:38 soho kernel: [    0.000000] Initializing cgroup subsys
cpu
Apr 25 13:35:38 soho kernel: [    0.000000] Linux version 2.6.38-ARCH
(tobias@T-POWA-LX) (gcc version 4.6.0 20110415 (prerelease) (GCC) ) #1
SMP PREEMPT Sun Apr 17 14:51:34 UTC 2011
Apr 25 13:35:38 soho kernel: [    0.000000] BIOS-provided physical RAM
map:

however at first sight, it could be related to reseirfs because I see a
lot of call to reseirfs_* functions in the call traces.

I am not able to reproduce it. I have not tried. It could work one or
two days before it freezes.

