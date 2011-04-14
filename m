Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1DNREt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:04:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34472 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab1DNREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:04:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LLHr7tlITv7iGelEBeNEXYJ65h3NU3BOHoE5huXdv+uPUUIxQ47FQB4U1QV86PMZbK
         mfM3QMBLuhMVme/O7/jMGCikza5yWOMWhD6uikgQq9ZCiufDvMe0GtzQyBHGeiAGtsdK
         n+9bmZ05LzbPDPo8SFdG8GIqt2DJ3+RkEtuC4=
Message-ID: <4DA727D9.3000904@gmail.com>
Date: Thu, 14 Apr 2011 18:59:05 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Milton Miller <miltonm@bga.com>, Nick Piggin <npiggin@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: synchronize_rcu when unregister_filesystem success
 not failure
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org> <4DA5ADA6.5060301@teksavvy.com> <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu> <ext4-masq@mdm.bga.com> <fs-unreg-rcu@mdm.bga.com> <BANLkTi=Tt8HRmqODM_qPAbGMeQ9UvVDXfA@mail.gmail.com>
In-Reply-To: <BANLkTi=Tt8HRmqODM_qPAbGMeQ9UvVDXfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/04/2011 17:52, Linus Torvalds ha scritto:
> On Thu, Apr 14, 2011 at 8:41 AM, Milton Miller<miltonm@bga.com>  wrote:
>>
>> While checking unregister_filesystem for saftey vs extra calls for
>> "ext4: register ext2 and ext3 alias after ext4" I realized that
>> the synchronize_rcu() was called on the error path but not on
>> the success path.
>
> Good catch.
>
> I think this is the bug that then caused us to do commit d863b50ab013
> ("vfs: call rcu_barrier after ->kill_sb()")
>
> That said, that commit says that "synchronize_rcu()" isn't enough, and
> uses rcu_barrier().
>
> Which _should_ mean that there are no actual users that care about RCU
> events by the time you actually hit "unregister_filesystem()".
>
> So I think your patch is correct, but won't actually matter. But maybe
> I'm missing something.
>
>> Should we call it in both?
>
> No, I think the success path is the one that would matter.
>
> Comments?
>

If I well remember the rcu_barrier was needed for the fs module 
unloading problem. In that case synchronize_rcu() wasn't enough. That 
said, I agree with you, it won't have any impact.

Marco
