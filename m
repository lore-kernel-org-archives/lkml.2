Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab2HYVPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 17:15:35 -0400
Received: from nctlincom01.orcon.net.nz ([60.234.4.74]:48951 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2HYVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 17:15:32 -0400
Message-ID: <5039406F.9040604@orcon.net.nz>
Date: Sun, 26 Aug 2012 09:15:27 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, Chris Zankel <chris@zankel.net>,
        "3.2.x.." <stable@vger.kernel.org>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        m68k <linux-m68k@vger.kernel.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Cris <linux-cris-kernel@axis.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, alpha <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com> <20120824212647.GU2472@linux.vnet.ibm.com> <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk> <20120825035047.GB3436@linux.vnet.ibm.com> <20120825131647.GA1994@somewhere> <20120825161806.GD3436@linux.vnet.ibm.com>
In-Reply-To: <20120825161806.GD3436@linux.vnet.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Sun, 26 Aug 2012 09:15:28 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Aug 26 09:15:29 2012
X-DSPAM-Confidence: 0.7006
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=G2; city=Porirua; latitude=-41.1333; longitude=174.8500; http://maps.google.com/maps?q=-41.1333,174.8500&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06HP9p2gc - 49d4521b9b8f - 20120826
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/12 04:18, Paul E. McKenney wrote:
> On Sat, Aug 25, 2012 at 03:16:49PM +0200, Frederic Weisbecker wrote:
>> On Fri, Aug 24, 2012 at 08:50:47PM -0700, Paul E. McKenney wrote:
>>> On Sat, Aug 25, 2012 at 02:19:14AM +0100, Ben Hutchings wrote:
>>>> On Fri, 2012-08-24 at 14:26 -0700, Paul E. McKenney wrote:
>>>>> On Thu, Aug 23, 2012 at 04:58:24PM +0200, Frederic Weisbecker wrote:
>>>>>> Hi,
>>>>>>
>>>>>> Changes since v1:
>>>>>>
>>>>>> - Fixed preempt handling in alpha idle loop
>>>>>> - added ack from Geert
>>>>>> - fixed stable email address, sorry :-/
>>>>>>
>>>>>> This time I built tested everywhere but: h8300 (compiler internal error),
>>>>>> and mn10300, parisc, score (cross compilers not available in
>>>>>> ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/)
>>>>>>
>>>>>> For testing, you can pull from:
>>>>>>
>>>>>> git://github.com/fweisbec/linux-dynticks.git
>>>>>> 	rcu/idle-fix-v2 
>>>>>>
>>>>>> Thanks.
>>>>>
>>>>> I have queued these on -rcu branch rcu/idle:
>>>>>
>>>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
>>>>>
>>>>> This problem has been in place since 3.3, so it is hard to argue that
>>>>> it is a regression for this merge window.  I have therefore queued it
>>>>> for 3.7.
>>>>
>>>> I don't follow that; I would expect any serious bug fix (serious enough
>>>> for a stable update) to be acceptable for 3.6 at this point.
>>>
>>> OK, if any of the arch maintainers wishes to submit the patch to 3.6,
>>> they are free to do so -- just let me know and I will drop the patch from
>>> my tree.
>>>
>>> That said, all this does is cause spurious warnings to be printed, so
>>> not sure it really qualifies as serious.  But I am happy to leave that
>>> decision with the individual arch maintainers -- it is their arch,
>>> after all, so their decision.
>>
>> Couldn't that cause hung tasks due to long lasting synchronize_rcu() ?
> 
> In theory, definitely.  In practice, they haven't been running into it,
> or they would be reporting hangs.

I am hereby reporting that RCU CPU stall warnings and hung tasks are
being experienced on SMP kernels built for generic Alpha. This problem
dates back quite a few kernel releases. The discussed patches appear to
fix the problem.

A backport to the 3.2 kernel, of at least the Alpha patches, would be
very much appreciated! :-)

Cheers
Michael.
