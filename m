Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1KHMnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:43:19 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:45760 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KHMnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:43:17 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Nov 2011 07:43:17 EST
Message-ID: <4EB92181.5030500@seznam.cz>
Date: Tue, 08 Nov 2011 13:33:05 +0100
From: Jiri Polach <jiri.polach@seznam.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: 647095@bugs.debian.org
CC: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz> <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>
In-Reply-To: <4EAE9D3A.7000108@atlas.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 2:06 PM, Clarinet wrote:
> On 10/30/2011 4:25 PM, Ben Hutchings wrote:
>> On Sun, 2011-10-30 at 07:05 -0400, Jiri Polach wrote:
>>> Package: linux-2.6
>>> Version: 2.6.39-3~bpo60+1
>>> Severity: normal
 >>
 >> ...
>>
>> That might be too large a range for developers to consider. Can you
>> test some versions between 2.6.35.7 and 2.6.38.6 (bisection)?
>
> OK, after another day of testing it seems that the problem appears in
> 2.6.38.1, because
>
> * linux 2.6.37.6 - custom compiled from source - ok
> * linux 2.6.38.1 - custom compiled from source - not ok

On Ben's advice I am trying to locate the commit that causes the problem 
to appear more precisely using 'git bisect'. However, too many of 
generated revisions are unbootable so I have to use 'bisect skip' 
frequently. I started with 4059 revisions to test (roughly 12 steps) and 
after 15 steps I still have 2902 revisions to test (rougly 12 steps).

Is there any way to speed this process up? I tried to do bisection 
manually but I do not understand git enough to be able to do this 
efficiently.

My current bisect log is below.

Jiri Polach

---

git bisect start
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect good 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5
# bad: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
git bisect bad 521cb40b0c44418a4fd36dc633f575813d59a43d
# bad: [c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470] Linux 2.6.38-rc1
git bisect bad c56eb8fb6dccb83d9fe62fd4dc00c834de9bc470
# good: [c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4] Linux 2.6.37-rc1
git bisect good c8ddb2713c624f432fa5fe3c7ecffcdda46ea0d4
# good: [3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5] Linux 2.6.37
git bisect good 3c0eee3fe6a3a1c745379547c7e7c904aa64f6d5
# skip: [ecacc6c70cf77a52a22af66c879873202522d6ce] Merge branch 
'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6
git bisect skip ecacc6c70cf77a52a22af66c879873202522d6ce
# skip: [22113efd00491310da802f3b1a9a66cfcf415fac] mmc: Test bus-width 
for old MMC devices
git bisect skip 22113efd00491310da802f3b1a9a66cfcf415fac
# good: [233cbe5b94096f95ba7bca2162d63275b0b90b5b] OMAP2+: hwmod: Update 
the sysc_cache in case module context is lost
git bisect good 233cbe5b94096f95ba7bca2162d63275b0b90b5b
# skip: [443e6221e465efa8efb752a8405a759ef1161af9] Merge branch 
'for_linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86
git bisect skip 443e6221e465efa8efb752a8405a759ef1161af9
# good: [9e3be1edbe5ca57df51140b523168237b3a01f4d] Merge branch 
'for-2.6.37' into HEAD
git bisect good 9e3be1edbe5ca57df51140b523168237b3a01f4d
# good: [6c869e772c72d509d0db243a56c205ef48a29baf] Merge branch 
'perf/urgent' into perf/core
git bisect good 6c869e772c72d509d0db243a56c205ef48a29baf
# skip: [f451171c5ac829e55581c81caf2cb01e1c0a5c5f] i2c-algo-bit: 
Refactor adapter registration
git bisect skip f451171c5ac829e55581c81caf2cb01e1c0a5c5f
# good: [aa5cbf8a70f57c5360ce1bfef692b357c866ae7f] [SCSI] qla2xxx: Use 
sg_next to fetch next sg element while walking sg list.
git bisect good aa5cbf8a70f57c5360ce1bfef692b357c866ae7f
# skip: [9b3ffe523af895f6b969b971079da4c06c2743af] ARM: ns9xxx: irq_data 
conversion.
git bisect skip 9b3ffe523af895f6b969b971079da4c06c2743af
# good: [c0b33bdc5b8d9c1120dece660480d4dd86b817ee] [media] 
gspca-stv06xx: support bandwidth changing
git bisect good c0b33bdc5b8d9c1120dece660480d4dd86b817ee
# good: [d7ae30f073a179a9cebd663e7502843ddf4ba672] mac80211: document 
workqueue
git bisect good d7ae30f073a179a9cebd663e7502843ddf4ba672
# skip: [949f6711b83d2809d1ccb9d830155a65fdacdff9] Merge branch 
'staging-next' of 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect skip 949f6711b83d2809d1ccb9d830155a65fdacdff9
# good: [40e44399301b6dbd997408a184140b79b77f632d] omap2+: Add struct 
omap_board_data and use it for platform level serial init
git bisect good 40e44399301b6dbd997408a184140b79b77f632d
# skip: [8f9b54a35a70b604ebd2b2f2e7e04eabd0ff8a54] Decompressors: check 
for write errors in decompress_unlzo.c
git bisect skip 8f9b54a35a70b604ebd2b2f2e7e04eabd0ff8a54
# good: [190683a9d5457e6d962c232ffbecac3ab158dddd] net: net_families 
__rcu annotations
git bisect good 190683a9d5457e6d962c232ffbecac3ab158dddd
# skip: [c0afc916029c02a8650e533392893b3da6326d1e] ARM: ep93xx: irq_data 
conversion.
git bisect skip c0afc916029c02a8650e533392893b3da6326d1e
# good: [9ac4e613a88d7f6a7a9651d863e9c8f63b582718] mtd: OneNAND: 
OMAP2/3: prevent regulator sleeping while OneNAND is in use
git bisect good 9ac4e613a88d7f6a7a9651d863e9c8f63b582718
# skip: [2b6203bb7d85e6a2ca2088b8684f30be70246ddf] qeth: enable 
interface setup if LAN is offline
git bisect skip 2b6203bb7d85e6a2ca2088b8684f30be70246ddf
# good: [8ec98fe0b4ffdedce4c1caa9fb3d550f52ad1c6b] jz4740-battery: 
Protect against concurrent battery readings
git bisect good 8ec98fe0b4ffdedce4c1caa9fb3d550f52ad1c6b
# good: [dc69e2e9fcd7c613eb744ea3b9c4ee9ca554e822] ceph: associate 
requests with opening sessions
git bisect good dc69e2e9fcd7c613eb744ea3b9c4ee9ca554e822
# good: [3e2a037c1de79af999a54581cbf1e8a5c933fd95] ARM: PL08x: fix 
sparse warnings
git bisect good 3e2a037c1de79af999a54581cbf1e8a5c933fd95
# good: [0b97fee0ef9b0a0445520f90980410f905c6f9da] powerpc/mm: Avoid 
avoidable void* pointer
git bisect good 0b97fee0ef9b0a0445520f90980410f905c6f9da
# skip: [a7f5a5fcd9f13afd3471a0de8c1fdaa8f989497c] ixgbe: fix for link 
failure on SFP+ DA cables
git bisect skip a7f5a5fcd9f13afd3471a0de8c1fdaa8f989497c
# good: [ba5d1012292403c8037adf4a54c4ec50dfe846c4] xen/gntdev: stop 
using "token" argument
git bisect good ba5d1012292403c8037adf4a54c4ec50dfe846c4
# good: [b646d90053f887c1bc243191e693a9b02d09f2c2] r8169: magic.
git bisect good b646d90053f887c1bc243191e693a9b02d09f2c2

