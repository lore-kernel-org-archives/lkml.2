Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1ELOW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:22:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55706 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1ELOW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:22:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zwxz5yANJRDMdM0dY0mbGSacpVx4VA1g4GogR6OC/tpKHL9ASAgAGhJOGPpqOUNYhX
         CeYMUOoWyGrF7Bag2ASbcEXfNABPKofv1wPA9ujECv2E2Zk1cYKYM73TTay8R96UeaJl
         fLCrC51t5FM+f2zVA+OVnt1fj/11iU00uTSiM=
MIME-Version: 1.0
In-Reply-To: <20110512122658.GB3639@zhy>
References: <4DCAB8A2.8060605@linux.com>
	<20110512105756.GA3329@zhy>
	<4DCBCE56.2010607@gmail.com>
	<20110512122658.GB3639@zhy>
Date: Thu, 12 May 2011 22:22:57 +0800
Message-ID: <BANLkTim1pGQvGwvM09C0LCkYwmDP3uFB2Q@mail.gmail.com>
Subject: Re: lock_stat &rq->lock/1 class name meaning
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 8:26 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Thu, May 12, 2011 at 02:11:02PM +0200, Juri Lelli wrote:
>> Thanks!
>>
>> On 05/12/2011 12:57 PM, Yong Zhang wrote:
>> >On Wed, May 11, 2011 at 06:26:10PM +0200, Juri Lelli wrote:
>> >>Hi,
>> >>I'm trying to collect contention statistics through /proc/lock_stat
>> >>about scheduler data structures.
>> >>
>> >>What I obtain if a do "cat /proc/lock_stat" is something like:
>> >>...
>> >>&rq->lock:         13128          13128           0.43
>> >>[...]
>> >>
>> >>I guess the first one is about the per-rq (per-CPU) spinlock, but
>> >>what about the second? What the "/1" stands for?
>> >
>> >It is also rq but it's subclass is 1.
>> >
>> >Take a look at raw_spin_lock_nested(&this_rq->lock, SINGLE_DEPTH_NESTING);
>> >in _double_lock_balance()
>>
>> Ok, I've put more light on this also looking at lockdep.h comments
>> and lockdep-design documentation.
>>
>> Since I'm probably not the only one having troubles undestanding
>> lock_stat output, maybe could be useful to add something on this
>> inside lockstat documentation (I can try to do this). What you
>> think?
>
> Any improvement will be good :)

I think Documentation/lockstat.txt is out of date,
the last change of this file can be back to
Thu Nov 19 13:54:05 2009.
