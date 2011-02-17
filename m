Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1BQFmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 00:42:52 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34563 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1BQFmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 00:42:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gluLNmurGo5jroXjNjpiXZWdT0MQA0zpAxKzI/Hg8wlG9bIWzun1+zqHk0onElQpOz
         aXqSBqNc3thJEzOoIZFd6+UNrdjDRXuelnDOn+tg+lwtCpK/zLwXJOomLkWC8jT8v9+w
         /6r/SsyA3jeAs6O5b5Xw7kWyN88xKicrkN5sE=
Date: Thu, 17 Feb 2011 13:42:37 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Fwd: IGMP and rwlock: Dead ocurred again on TILEPro
Message-ID: <20110217054237.GB2653@cr0.nay.redhat.com>
References: <AANLkTimj+_8cBz0gcEyF1889xK2HdF4SQDSK8DiY-4Gs@mail.gmail.com>
 <20110217044917.GA2653@cr0.nay.redhat.com>
 <AANLkTikkro-_9pv5uJ4+SqYh9Fr480_96Wh1Pv6Pvtez@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikkro-_9pv5uJ4+SqYh9Fr480_96Wh1Pv6Pvtez@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 01:04:14PM +0800, Cypher Wu wrote:
>>
>> Have you turned CONFIG_LOCKDEP on?
>>
>> I think Eric already converted that rwlock into RCU lock, thus
>> this problem should disappear. Could you try a new kernel?
>>
>> Thanks.
>>
>
>I haven't turned CONFIG_LOCKDEP on for test since I didn't get too
>much information when we tried to figured out the former deadlock.
>
>IGMP used read_lock() instead of read_lock_bh() since usually
>read_lock() can be called recursively, and today I've read the
>implementation of MIPS, it's should also works fine in that situation.
>The implementation of TILEPro cause problem since after it use TNS set
>the lock-val to 1 and hold the original value and before it re-set
>lock-val a new value, it a race condition window.
>

I see no reason why you can't call read_lock_bh() recursively,
read_lock_bh() is roughly equalent to local_bh_disable() + read_lock(),
both can be recursive.

But I may miss something here. :-/
