Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab1D3DjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:39:09 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:55195 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755853Ab1D3DjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:39:07 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: Re: 2.6.39-rc5-git2 boot crashs
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 29 Apr 2011 23:39:06 -0400
Message-ID: <web-515898476@zbackend1.aha.ru>
In-Reply-To: <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
References: <web-515866242@zbackend1.aha.ru>
 <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
 <20110430025545.GI9487@ZenIV.linux.org.uk>
 <20110430030243.GJ9487@ZenIV.linux.org.uk>
 <BANLkTi=9Zq8AdGMyfwyp1nwyjD+PCGQydA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At my reclamation thread about 2.6.39-rc3,4 crashs, I 
informed that there was a reset-resistent change of the 
system after crashs, so that on subsequent boots (after a 
'primary' crash rather at the end of booting) it happened 
an early 'secondary'  crash at the time of initializing 
ata0, with funny effects like that the grafic card (or 
anything else) was identified as an ata device, with 
subsequent 'read erros' on it and crash. This 'secondary' 
effect repeated and repeated and gone away only at booting 
with a normal kernel (2.6.38.4 or 2.6.26.2). But if 
afterwards booting again with 2.6.39-rc3 or -rc4 , then at 
the end of the boot it crashed, and at subsequent boots 
again continued this reset-resistent effect that it crasha 
again and again with ata0 problems, until I reboot with 
2.6.38.4 or 2.6.26.2 , or waiting 5 minutes (perhaps until 
the memory discharged).

All these problems dont happen with 2.6.38.4 or 2.6.26.2

Werner Landgraf


================================================
On Fri, 29 Apr 2011 20:09:16 -0700
  Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, Apr 29, 2011 at 8:02 PM, Al Viro 
><viro@zeniv.linux.org.uk> wrote:
>>
>> Wait a bit; _can_ we get there with non-NULL 
>>->s_master_inode et.al.?
>> iput(NULL) is a noop...  I don't think so, since 
>>logfs_init_journal()
>> is not called until after we initialize that list.
>>
>> Not that I'd object against taking that initialization 
>>earlier, of course,
>> but there seems to be something else going on...  Which 
>>iput() it is?
> 
> Not something I can guess from the oops, sadly. Gcc has 
>inlined
> everything into logfs_mount, and the "0x44f/0x5cc" 
>offset isn't very
> helpful (with the same compiler version and config 
>options it would be
> possible to figure it out).
> 
> But looking at it, logfs_init_mapping() is currently 
>called before
> "s_freeing_list" is initialized, and it sets up at least
> s_mapping_inode. So if anything fails between that point 
>and the point
> where we initialize s_freeing_list, I think we're toast.
> 
> I didn't check the other inodes, but at least that one 
>does seem to be
> potentially non-NULL. No?
> 
>                 Linus
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
