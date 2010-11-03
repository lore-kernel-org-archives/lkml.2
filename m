Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0KCXCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:02:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab0KCXCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:02:16 -0400
Message-ID: <4CD1E9E8.4000302@redhat.com>
Date: Wed, 03 Nov 2010 19:02:00 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        lacombar@gmail.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <20101009224041.GA901@sepie.suse.cz> <4CD1E232.30406@redhat.com> <4CD1E679.5080202@suse.cz>
In-Reply-To: <4CD1E679.5080202@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 03-11-2010 18:47, Michal Marek escreveu:
> On 3.11.2010 23:29, Mauro Carvalho Chehab wrote:
>> Em 09-10-2010 18:40, Michal Marek escreveu:
>>> The following changes since commit cb655d0f3d57c23db51b981648e452988c0223f9:
>>>
>>>   Linux 2.6.36-rc7 (2010-10-06 13:39:52 -0700)
>>>
>>> are available in the git repository at:
>>>   git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes
>>>
>>> Arnaud Lacombe (1):
>>>       kconfig: delay symbol direct dependency initialization
>>
>> This patch generated a regression with V4L build. After applying it, some Kconfig
>> dependencies that used to work with V4L Kconfig broke.
> 
> You mean, the dependencies trigger a warning now, right? Also, you are
> replying to my pull request for 2.6.36-rc8, but that pull request also
> included "kconfig: Temporarily disable dependency warnings", so 2.6.36
> final is NOT affected by this, just to clarify. 2.6.37-rc1 reverted this
> workaround and I hope we come to some solution now. BTW,
> http://www.kerneltrap.com/mailarchive/linux-kernel/2010/10/7/4629122/thread
> is how a very similar issue was fixed in the i2c Kconfig (commit 0a57274
> in 2.6.37-rc1 now).

Well, I'm seeing those warnings on 2.6.37-rc1, after the patch that re-enable
the warnings. Just reverting the delay symbol direct dependency init changeset 
makes the warnings stop.

I didn't really try to run lots of tests to be sure that they actually break
anything, or if they are just unwanted warnings, but, in any case, we need a
fix before the end of .37 cycle.

A solution like what was done on i2c doesn't seem nice, as it will require lots
of artificial changes at kconfig stuff. Maybe it would be better to just add
some logic at Kconfig file to specify those kind of menus without producing
warnings, of course assuming that actually won't break symbols dependency solve.

Thanks,
Mauro
anything.
