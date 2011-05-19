Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab1ESPAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:00:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54976 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1ESPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=NhuTuY8/DnRkMP5x0WAAI4cfTyTGJ12Xj+Fszfa72r6pU9SwH/eCcWsfykRVBF66Nc
         2MmoNGH7vbeHMwRVqPwcYpiT+irCOrF2gltbCx4LSNfgPg8PGxVof6qzU8JHUhipIDN4
         HveY5EQ1Ygslwv6KiroFXjI8MnQTn0FksNaCo=
MIME-Version: 1.0
In-Reply-To: <20110519145147.GA14658@localhost>
References: <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
 <20110514165346.GV6008@one.firstfloor.org> <BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
 <20110514174333.GW6008@one.firstfloor.org> <BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
 <20110515152747.GA25905@localhost> <BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
 <20110517060001.GC24069@localhost> <BANLkTi=TOm3aLQCD6j=4va6B+Jn2nSfwAg@mail.gmail.com>
 <BANLkTi=9W6-JXi94rZfTtTpAt3VUiY5fNw@mail.gmail.com> <20110519145147.GA14658@localhost>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 19 May 2011 11:00:24 -0400
X-Google-Sender-Auth: REcKtdmDjXc88-Oj1MvwoTDN74c
Message-ID: <BANLkTim4caSU_uRY1GLMh9D=8gctp34jMA@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:51 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > I had 6GB swap available, so there shouldn't have
>> > been any OOM.
>>
>> Yes. It's strange but we have seen such case several times, AFAIR.
>
> I noticed that the test script mounted a "ramfs" not "tmpfs", hence
> the 1.4G pages won't be swapped?

That's intentional.

I run LVM over dm-crypt on an SSD, and I thought that might be part of
the problem.  I wanted a script that would see if I could reproduce
the problem without stressing that system too much, so I created a
second backing store on dm-crypt over ramfs so that no real I/O will
happen.  The script is quite effective at bringing down my system, so
I haven't changed it.

(I have 6GB of "real" swap on the LVM, so pinning 1500MB into RAM
ought to cause some thrashing but not take the system down.  And this
script with a larger ramfs does not take down my desktop, which is an
8GB Sandy Bridge box.  But whatever the underlying bug is seems to
mainly affect Sandy Bridge *laptops*, so maybe that's expected.)

--Andy

>
> Thanks,
> Fengguang
>
