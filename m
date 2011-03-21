Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab1CUFa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 01:30:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53715 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1CUFaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 01:30:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HLqaWzV+6Mnu67XntJjbF8XhsWZDgsAb3AHn8Wu5vLD1fPKMG2Qz36pNXPZaWVdmTz
         PDSrS5zCwIzhuCcKu94gJSMdkNVV0o1wtiD0WYRApTU2Vy2Kgv6A5S5HwDOSq1PIUCf6
         DqGhN5BKc82Grrf5xyWIIBvpjAlfY367i43BU=
MIME-Version: 1.0
In-Reply-To: <20110321033926.GP22723@ZenIV.linux.org.uk>
References: <AANLkTi=5pSyJVqOQUJ8wXbNpXogWcRdavswx9my0OzEX@mail.gmail.com>
	<20110321033926.GP22723@ZenIV.linux.org.uk>
Date: Mon, 21 Mar 2011 08:30:23 +0300
Message-ID: <AANLkTinKPfYdbAQWuzi5Wf-HadLfjT0hmDnMwJwkwf8N@mail.gmail.com>
Subject: Re: 2.6.39-rc0: umount tmpfs hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2011 06:39, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 21, 2011 at 05:24:08AM +0300, Alexander Beregalov wrote:
>> Hi
>>
>> kernel is 2.6.38-06507-ga952baa
>>
>> /etc/init.d/swap stop
>> runs
>> umount -a -t tmpfs
>>
>> which is hangs at
>>
>> $cat /proc/4453/stack
>> [<c1066332>] rcu_barrier_sched+0x32/0x40
>> [<c109fdca>] deactivate_locked_super+0x3a/0x60
>> [<c10a05f6>] deactivate_super+0x46/0x60
>> [<c10b6f2a>] mntput_no_expire+0x5a/0x90
>> [<c10b7a6d>] sys_umount+0x5d/0x300
>> [<c10b7d29>] sys_oldumount+0x19/0x20
>> [<c136eb50>] sysenter_do_call+0x12/0x36
>> [<ffffffff>] 0xffffffff
>
> rcu_barrier() hanging for some reason...  I really wonder what's going
> on there - missing rcu_read_unlock()?  Could you try to reproduce that
> sucker and, if possible, bisect it?

Yes, it's reproducible, but I'm bisecting another issue and have few
more such issues with the current kernel.
