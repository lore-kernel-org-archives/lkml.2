Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658Ab0HFTv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:51:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56948 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0HFTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aoe4Zq/QBXY05CjN025YENA16pftzVDF2PqsHVAfBd7F0mPWjR/xI6Fj49CH4jhGGJ
         t74dLbxphNhynZuNKmu33asllgIfA8lfsTOCy8sVMjIt8hoDY3QEBACYnL1zhoZMe/Bg
         FURw71hgbFzJZEtGBvq40GV5K9IMXEKzipfwI=
Message-ID: <4C5C67F0.8070408@gmail.com>
Date: Fri, 06 Aug 2010 12:52:16 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        JBeulich@novell.com, aris@redhat.com, catalin.marinas@arm.com,
        jacmet@sunsite.dk, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix make oldconfig
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTi=hYsksUJUsrETjFouLDiKhwQHgD2oQ7XLyrOC-@mail.gmail.com> 	<4C5B64EA.2000804@gmail.com> <AANLkTikpsvpHuB-mWVfmqTRRMvbvhJz2LmoYBgtn4NQE@mail.gmail.com> 	<20100806051354.GA24343@merkur.ravnborg.org> <4C5BE229.1090801@suse.cz> 	<AANLkTimWHnxbYzkJ1KhuS3DgTuSRz-gMnzEJvbsY835g@mail.gmail.com> 	<20100806175217.GA8944@merkur.ravnborg.org> <AANLkTimkngSrDFUcHOySkf22yY3Qr3p+m2qnwDzre+zk@mail.gmail.com>
In-Reply-To: <AANLkTimkngSrDFUcHOySkf22yY3Qr3p+m2qnwDzre+zk@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 11:09 AM, Linus Torvalds wrote:
> On Fri, Aug 6, 2010 at 10:52 AM, Sam Ravnborg<sam@ravnborg.org>  wrote:
>>
>> Hmm, I wonder why you call oldconfig explicitly?
>>
>> A plain "make -j16" executes "silentoldconfig" if there
>> is any changes in a Kconfig* file or in .config.
>> Just double checked and it works as I expected.
>>
>> So you are asked if there is any new options anyway even
>> if you skip your "oldconfig" step.
>
> Try this:
>
>     git clean -dqfx
>     make -j16>  ../makes
>
> It doesn't work, because "make silentconfig" will say
>
>    ***
>    *** You have not yet configured your kernel!
>    *** (missing kernel config file ".config")
>    ***
>    *** Please run some configurator (e.g. "make oldconfig" or
>    *** "make menuconfig" or "make xconfig").
>    ***
>
> which is why I always run "make oldconfig".
>
> Sure, I could do it only when I need to, but quite frankly, it's much
> easier to just always do the thing that works, rather than try
> something that doesn't work, do something else, and then re-try the
> thing that can fail.
>
>                       Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


the above command does break over here. using the make oldconfig command 
seems to be working after I did the make menuconfig.

Now before doing all of this I did make a copy of the entire kernel for 
a new system Im building(clfs) so I went into that tree and did a make 
oldconfig and(luckily) hit the non responsive oldconfig thing that Linus 
had originally posted.

here is a strace of when make oldconfig was not working(with git log at 
the top)

http://fpaste.org/317B/

and strace of a git pull today and make oldconfig does not crap out and 
starts asking me y/n options:

http://fpaste.org/QWWn/

hope this helps with debugging and such.

Justin P. Mattock
