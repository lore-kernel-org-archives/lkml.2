Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1CUGSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 02:18:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44030 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1CUGSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 02:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rSkVK4/KrovpjwI2S0y/aA2hj6pvCR6+r+Jp2VGr3A50Od0i2Wo5iLgknx60A7xbSZ
         857sRYmXAAsJUTQYlBOnzzMYzTtXgp3NCqDO5+VQq9pg5VOyc0SFGvd3yamWU3VONao4
         JAUq/vEYPyg+vmDNwLnDKDqf6zrIg7b4BKqBQ=
MIME-Version: 1.0
In-Reply-To: <20110321055413.GT22723@ZenIV.linux.org.uk>
References: <AANLkTi=5pSyJVqOQUJ8wXbNpXogWcRdavswx9my0OzEX@mail.gmail.com>
	<20110321033926.GP22723@ZenIV.linux.org.uk>
	<AANLkTinKPfYdbAQWuzi5Wf-HadLfjT0hmDnMwJwkwf8N@mail.gmail.com>
	<20110321055413.GT22723@ZenIV.linux.org.uk>
Date: Mon, 21 Mar 2011 09:18:33 +0300
Message-ID: <AANLkTinXHoruafH6wa0NH8N+GxYTABLzGr9BiRXV2+AN@mail.gmail.com>
Subject: Re: 2.6.39-rc0: umount tmpfs hangs
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 March 2011 08:54, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 21, 2011 at 08:30:23AM +0300, Alexander Beregalov wrote:
>
>> > rcu_barrier() hanging for some reason... ??I really wonder what's going
>> > on there - missing rcu_read_unlock()? ??Could you try to reproduce that
>> > sucker and, if possible, bisect it?
>>
>> Yes, it's reproducible, but I'm bisecting another issue and have few
>> more such issues with the current kernel.
>
> Could you post the reproducer?  Simple mounting tmpfs and umount explicitly
> doesn't seem to trigger it; doing some IO on that fs doesn't change that,
> ditto for umount done by shutdown instead of doing it manually...

For me it is just shutting down.
While bisecting another issue I found this range for bisection:
ceda86a108671294052cbf51660097b6534672f5 good
7a6362800cb7d1d618a697a650c7aaed3eb39320 bad

but only if the bug is 100% reproducible with my test, I can't be sure yet.
