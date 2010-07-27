Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0G0Soh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:44:37 -0400
Received: from mx02.infracom.it ([62.196.48.10]:43100 "EHLO mx02.infracom.it"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234Ab0G0Sod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:44:33 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Jul 2010 14:44:33 EDT
Message-ID: <4C4F27C2.6050001@gmail.com>
Date: Tue, 27 Jul 2010 20:38:58 +0200
From: Roberto Oppedisano <roberto.oppedisano@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100710 Thunderbird/3.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35 suspend regression (bisected)
References: <4C4C9E40.7070209@infracom.it> <201007260018.14300.rjw@sisk.pl> <20100725223508.GA9885@merkur.ravnborg.org>
In-Reply-To: <20100725223508.GA9885@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 26/07/2010 00:35, Sam Ravnborg wrote:
> On Mon, Jul 26, 2010 at 12:18:14AM +0200, Rafael J. Wysocki wrote:
>> On Sunday, July 25, 2010, Roberto Oppedisano wrote:
>>> My HP6730B (x86_64 kernel, uptodate lubuntu Lucid installed) fails to suspend
>>> on recent git kernels, the screen goes black (backlight on) and stays there forever.
>>>
>>> Here's what I found from a bisect.
>>>
>> Does it work if you revert that commit?
> Roberto wrote:
>
>>> Alas reverting that single commit on current linux/master does not
>>> solve the issue so it could be that I did something wrong... anyway
>>> here the log of the bisect:
> So I guess not...
[resending due to lklm reject... gmail defaults to html email, sorry for 
duplicate emails]

I did bisect again and I did get a different result:

c1518f12bab97a6d409a25aaccb02dc8895800f3 is the first bad commit

git bisect start
# good: [e40152ee1e1c7a63f4777791863215e3faa37a86] Linus 2.6.34
git bisect good e40152ee1e1c7a63f4777791863215e3faa37a86
# bad: [1a041a23da7c77b53c71fe11b4f940388bee37b1] Merge branch 
'x86-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 1a041a23da7c77b53c71fe11b4f940388bee37b1
# good: [7f02ab3ce3c7e093c414fcbd93bdc591cc4419d0] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty-2.6
git bisect gdinf ood 7f02ab3ce3c7e093c414fcbd93bdc591cc4419d0
# good: [7839ec78214ecf477cc9e2862233b8d9fcf4ec58] gpiolib: document 
that names can contain printk format specifiers
git bisect good 7839ec78214ecf477cc9e2862233b8d9fcf4ec58
# bad: [e620d1e39aa33b43bed96aa7f2ebbc88914aed58] Merge branch 
'v4l_for_2.6.35' of 
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
git bisect bad e620d1e39aa33b43bed96aa7f2ebbc88914aed58
# good: [021fad8b706849c091f6e682bc5df3ce4f9ab4d7] Merge branch 
'x86-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect good 021fad8b706849c091f6e682bc5df3ce4f9ab4d7
# good: [d4376802999d478a103868d7e7b1f473e4a387af] Merge branch 
'fix/asoc' into for-linus
git bisect good d4376802999d478a103868d7e7b1f473e4a387af
# good: [d7940b04fa441b06b69f05faef43c5fb2156ab72] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
git bisect good d7940b04fa441b06b69f05faef43c5fb2156ab72
# good: [5c331fc8c19e181bffab46e9d18e1637cdc47170] V4L/DVB: dvb-core: 
Fix ULE decapsulation bug
git bisect good 5c331fc8c19e181bffab46e9d18e1637cdc47170
# good: [a094c0afc3515aaf962dd0793f3b23fe67e6b192] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
git bisect good a094c0afc3515aaf962dd0793f3b23fe67e6b192
# good: [2a0ab2cd73c26835e635ed4e3868f983519048fb] drbd: Reduce verbosity
git bisect good 2a0ab2cd73c26835e635ed4e3868f983519048fb
# good: [1abec4fdbb142e3ccb6ce99832fae42129134a96] block: make 
blk_init_free_list and elevator_init idempotent
git bisect good 1abec4fdbb142e3ccb6ce99832fae42129134a96
# good: [bd62307b20ff864c48541e46c3ee2bb9cc330f64] V4L/DVB: ivtv: Avoid 
accidental video standard change
git bisect good bd62307b20ff864c48541e46c3ee2bb9cc330f64
# bad: [c1518f12bab97a6d409a25aaccb02dc8895800f3] Merge branch 
'rc-fixes' of 
git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6
git bisect bad c1518f12bab97a6d409a25aaccb02dc8895800f3
# good: [cbab05f041a4cff6ca15856bdd35238b282b64eb] gconfig: fix build 
failure on fedora 13
git bisect good cbab05f041a4cff6ca15856bdd35238b282b64eb

Trying to revert that commit gives:

$ git bisect reset
$ git revert c1518f12bab97a6d409a25aaccb02dc8895800f3
fatal: Commit c1518f12bab97a6d409a25aaccb02dc8895800f3 is a merge but no 
-m option was given.

How am I supposed to proceed now ? (sorry I'm a git newbie)

R
