Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab0HLLLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 07:11:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45701 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365Ab0HLLLY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 07:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sS7QNQ/iYPidXHyoFqNMIk8+cdO5mXfuGSGDDuRkcMFZyHW4MzzBm34pTFy1GLTgD9
         4UhJn5+lpYxOHVo5ZpR93ievcTvpCUg+ghIGqDKwPZMix1XRWpLSMyLOAhqZTcuIeVau
         iBWn8B2SNHRNs/QWxXWrCWobQOxHxYkBoq4Cw=
MIME-Version: 1.0
In-Reply-To: <E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
References: <20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<AANLkTikwHaKpLdRdxmZj6JDJnsZ+o-jzbVcXhRW3Jmd9@mail.gmail.com>
	<20100811222854.GJ2516@linux.vnet.ibm.com>
	<AANLkTimahmGikeai8QnAxCy45deT00-6T7h-eA-NqL4G@mail.gmail.com>
	<20100812010612.GL2516@linux.vnet.ibm.com>
	<AANLkTinVV1NVHFPeO0p_e2pCtNwTNB932q9tbu9MMD3_@mail.gmail.com>
	<20100812034435.GA7403@linux.vnet.ibm.com>
	<AANLkTi=RD=eM_gpc7FfRq0923sUbARmZ2+4-m+fLibYC@mail.gmail.com>
	<E3F3D3E1-4DF7-47E3-895D-95F6BC22CCC4@mit.edu>
Date: Thu, 12 Aug 2010 14:11:22 +0300
Message-ID: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:47 PM, Theodore Tso <tytso@mit.edu> wrote:
> One thing I'm not clear on --- what's your goal?   Is your goal to keep suspend-blockers out of the kernel?   Is it to try to convince the android team suspend-blockers are a bad idea and to change Android to not use them?  Is it to push some other agenda?  Is it to discourage the Android team from trying to waste more time trying to get suspend-blockers (or equivalent functionality) from being added into the kernel?

My goal is to shine light. I've heard many invalid arguments in favor
of suspend blockers, I want to shut them down.

In my mind it's crystal clear that independently of what opportunistic
suspend is supposed to be fixing, the fact of the matter is that it's
not a silver bullet as it's claimed to be.

So far, nobody has refuted these:
 1) opportunistic suspend needs a good behaved user-space to work properly
 2) if suspend blockers are enabled in a system, *all* user-space must
implement them to work correctly
 3) implementing suspend blockers in user-space is not a straight-forward task
 4) there's a point where sleeping (not doing work) has diminished returns

So, as the length of this thread has shown, the benefits of
opportunistic suspend are *dubious* at best, and more likely not worth
the changes needed in user-space which eventually will get pretty
close to what suspend blockers can achieve even in ideal circumstances
by just doing dynamic PM.

-- 
Felipe Contreras
