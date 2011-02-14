Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405Ab1BNR5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 12:57:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1BNR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 12:57:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rPSc1GHBdCob6VIXGxIGie87Ewx4SVB6Z6tGIV6DfYol1jRofl2i8HZBHasMoUs4Rv
         XLR8oY8DSh4VPm2NM8AuCWIXztNOSNtOxan7WhWG5uJvV8ZSJWJQeW1+bMTsG35EjLpB
         VUwa0UIqKCNLPQ/8NhPhMjMKlBqA9aPI+qUNA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinmaojfNDYk1i4jMP33MmEQDur9XZvFp=qhV01e@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
	<d44ddcf1d1e0813b3ce2b3872c7c702a31b62894.1290852959.git.npiggin@kernel.dk>
	<AANLkTi=pj-pLYVSrU+6+BtioCWLod2ueZecNaap619fw@mail.gmail.com>
	<AANLkTik3ScP5rvR2bOXOEEH8SNZGg+xO6Gy32CW3XmU6@mail.gmail.com>
	<AANLkTinVP=OuJ-3u9pHdDuuKJoVrP4Unr5Dx1x=qHtXC@mail.gmail.com>
	<AANLkTimUjC8B0=nn5+yDshzp0hy6Zk1wxYHWEZbk83Tf@mail.gmail.com>
	<AANLkTi=or1Ya21Am8Dr4KVHgqkwvNxFwgn407=wxRfVa@mail.gmail.com>
	<AANLkTinmaojfNDYk1i4jMP33MmEQDur9XZvFp=qhV01e@mail.gmail.com>
Date: Mon, 14 Feb 2011 09:57:04 -0800
Message-ID: <AANLkTimuGihJsCQ_LwWWyX-PJdqxtzKK_7ZbgcHZAatg@mail.gmail.com>
Subject: Re: [PATCH 17/46] fs: Use rename lock and RCU for multi-step operations
From: Yehuda Sadeh Weinraub <yehudasa@gmail.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org, jaschut@sandia.gov
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 9:18 PM, Nick Piggin <npiggin@gmail.com> wrote:
> On Wed, Jan 26, 2011 at 9:10 AM, Yehuda Sadeh Weinraub
> <yehudasa@gmail.com> wrote:
>> On Wed, Jan 19, 2011 at 2:32 PM, Nick Piggin <npiggin@gmail.com> wrote:
>>> On Thu, Jan 20, 2011 at 9:27 AM, Yehuda Sadeh Weinraub
>>> <yehudasa@gmail.com> wrote:
>>>> On Tue, Jan 18, 2011 at 2:42 PM, Nick Piggin <npiggin@gmail.com> wrote:
>>>>> On Wed, Jan 19, 2011 at 9:32 AM, Yehuda Sadeh Weinraub
>>>>
>>>>>> There's an issue with ceph as it references the
>>>>>> dentry->d_parent(->d_inode) at dentry_release(), so setting
>>>>>> dentry->d_parent to NULL here doesn't work with ceph. Though there is
>>>>>> some workaround for it, we would like to be sure that this one is
>>>>>> really required so that we don't exacerbate the ugliness. The
>>>>>> workaround is to keep a pointer to the parent inode in the private
>>>>>> dentry structure, which will be referenced only at the .release()
>>>>>> callback. This is clearly not ideal.
>>>>>
>>>>> Hmm, I'll have to think about it. Probably we can check for
>>>>> d_count == 0 rather than parent != NULL I think?
>>>>>
>>>>
>>>> That'll solve ceph's problem, don't know about how'd affect other
>>>> stuff. We'll need to know whether this is the solution, or whether
>>>> we'd need to introduce some other band aid fix.
>>>
>>> No I think it will work fine. Basically we just need to know whether
>>> we have been deleted, and if so then we restart rather than walking
>>> back up the parent.
>>>
>>> I'll send a patch in a few days. For the meantime, it's a rathe
>>> small window for ceph to worry about. So we'll have something
>>> before -rc2 which should be OK.
>>>
>>
>> I guess that it's a bit late for -rc2, should we assume that it'll be on -rc3?
>
> Yeah, I'm sorry I've been travelling and a bit disconnected.
>
> NFS folk are having a similar problem and looks like similar
> proposed fix will do it.
>
> http://marc.info/?l=linux-fsdevel&m=129599823927039&w=2
>
> So I think it is the best way to go to restore behaviour back to what
> filesystems already expect, to avoid more surprises in future.
>

Hi Nick,
   -rc4 is out and that issue is still broken. Do you have that patch
ready or should we push our workaround?

Thanks,
Yehuda
