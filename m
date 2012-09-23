Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2IWNdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 09:33:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab2IWNdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 09:33:04 -0400
Message-ID: <505F0F74.1040508@redhat.com>
Date: Sun, 23 Sep 2012 10:32:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Shaun Ruffell <sruffell@digium.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Kim Phillips <kim.phillips@freescale.com>, linux-edac@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: Linux 3.6-rc6
References: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com> <20120922005905.GA8335@digium.com> <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
In-Reply-To: <CA+55aFzCzF5DZvR6i=Jg+0abSzN_nbAVr7Ef1dzmR3_NNLWmfw@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Em 22-09-2012 15:57, Linus Torvalds escreveu:
> On Fri, Sep 21, 2012 at 5:59 PM, Shaun Ruffell <sruffell@digium.com> wrote:
>>
>> I posted patches [1,2,3] that resolve the issue for me. Shaohui Xie
>> also hit the issue and posted a slightly different patch [4]. The
>> patches are currently waiting for Mauro, who I understand is
>> catching up since returning from San Diego, to check them out.
>>
>> [1] http://marc.info/?l=linux-kernel&m=134764595921752&w=2
>> [2] http://marc.info/?l=linux-kernel&m=134764594721747&w=2
>> [3] http://marc.info/?l=linux-kernel&m=134764597921761&w=2
>> [4] http://marc.info/?l=linux-kernel&m=134753579818528&w=2
> 
> That first patch needs a sign-off from you, since you are passing on
> somebody elses patch.
> 
> Looking at that patch, the patch seems to be a memory leak (?) leaking
> the "channels" allocation, along with fixing an odd and incorrect
> kfree (and access) of mci->csrows[i]. If that is correct, please write
> a proper changelog. The current changelog for that thing is totally
> pointless, and doesn't actually explain what the patch *does*.
> 
> I'd also like some ack's from people, and I'd love to know which
> commit introduced the problem(s). If this problem is new to 3.6, I
> want to know what caused it, and if it is *not* new, then the thing
> needs to be marked for stable. Please?

This was caused by the edac core rewrite I made, merged for 3.6, that
replaced the usage of raw kobj in order to use, instead, struct device.

I tested the patches on several machines and they're OK. It took
me some time to test them, as I got flooded with ~400 patches for
review while I was out for KS/2012... It is taking some time for me to
dig into each of them, especially since I hit into some internal dead
lines.

The good news is that we are equipping several machines at Red Hat labs
with different memory configurations, with is allowing us to do a
comprehensive testset on the EDAC x86 drivers. We've got already 
some longstanding bugs there, as well as a few recent regressions.

So, in addition to the bugs noticed by Shaun and Fengguang, 
I also got bug fixes for 3 EDAC drivers (sb_edac, i3200 and i5000).

> Finally, if I'm supposed to apply patches, I really *really* want to
> see the patches sent to me explicitly, instead of having people post
> pointers to them on the web. I don't apply random stuff on the web, I
> want the "please take this patch" to be a case of people *explicitly*
> sending it to me with the proper sign-offs in place etc.
> 
> IOW, the "hey, you should apply that random patch that wasn't even
> sent to you" approach is not something I accept.

I just updated the patches today on my git tree (so, they should be
popping up tomorrow at -next).

So, I will send you tomorrow a pull request with all fixes I'm aware 
of for edac, after the -next merging.

If you prefer otherwise to merge them today, you can get those patches
with my SOB at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master


Thanks!
Mauro

-

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git master

for you to fetch changes up to ded6223cfb75c4b5f61a285eee10df98a0291460:

  sb_edac: Avoid overflow errors at memory size calculation (2012-09-23 10:16:36 -0300)

----------------------------------------------------------------
Fengguang Wu (1):
      edac_mc: fix kfree calls in the error path

Mauro Carvalho Chehab (3):
      i3200_edac: Fix memory rank size
      i5000: Fix the memory size calculation with 2R memories
      sb_edac: Avoid overflow errors at memory size calculation

Shaun Ruffell (2):
      edac: edac_mc_free() cannot assume mem_ctl_info is registered in sysfs
      edac: edac_mc no longer deals with kobjects directly


