Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1D3E3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 00:29:25 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:35850 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751907Ab1D3E3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 00:29:24 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Al Viro <viro@ZenIV.linux.org.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 30 Apr 2011 00:29:22 -0400
Message-ID: <web-515903686@zbackend1.aha.ru>
In-Reply-To: <20110430025545.GI9487@ZenIV.linux.org.uk>
References: <web-515866242@zbackend1.aha.ru>
 <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
 <20110430025545.GI9487@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For your information:
/ All these problems dont have with 2.6.38 , .1, .2, .3 , 
.4
/ At 2.6.38-rc1 or was it 37-rc1 there had a problem with 
khugepaged what I also reclaimed.  That was similar like 
now these crashs which are NOT visible in syslog, 
happening a few minutes until hours after booting (these 
crashs should be visible in syslog 10..30 seconds before I 
rebooting).   At that time, the problem was corrected with 
khugepaged.   But it's possible, that the correction at 
that time wasn't good enough, so that now, after some 
other changes, the same problem 'returned'.  Currently, 
since 2.6.39-rc1 it crashs ALWAYS if I zip or unzip files 
of some 100 M  or move big files.     It's possible that 
it is a problem with the memory administration.
/ I use gcc 4.3.3 and glibc 2.9
I hope this informations are useful for correct these 
problems.
wl

===================================================================
On Sat, 30 Apr 2011 03:55:45 +0100
  Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Fri, Apr 29, 2011 at 07:47:14PM -0700, Linus Torvalds 
>wrote:
>> On Fri, Apr 29, 2011 at 7:31 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > It looks like a NULL pointer dereference with offset 
>>4, so at a guess,
>> > super->s_freeing_list.next is NULL, and it's the 
>>"next->prev = entry"
>> > instruction that faults when inserting into that list.
>> >
>> > How/why would s_freeing_list be NULL? I have no idea. 
>>But it looks
>> > like a failed mount, so presumably it was never 
>>initialized.
>> 
>> Hmm. super->s_freeing_list is initialized pretty late in
>> logfs_read_sb(), and any error path _before_ that point 
>>will result in
>> a "goto err1" in logfs_get_sb_device() which will do 
>>various iputs
>> etc. All without that list initialized. That would seem 
>>to be the
>> cause of this, possibly triggered by Al's changes to 
>>->mount from
>> read_super.
> 
> Then it ought to be reproducible with much ealier 
>kernels.  Say, 2.6.37 or
> so...  That part of ->mount() series went in during last 
>Autumn...
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
