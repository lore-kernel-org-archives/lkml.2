Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab1E0BfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:35:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62032 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651Ab1E0BfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JnWfZ0GeR3jmxtGbu7O1+M4Oi0FMFCyxBDho0FEIpLbzWPE7ywjnLu2UiyAtDDMcp+
         sFM2a+h411rv2If1PMYSx0UiNoc45jEyKl0sACUHGGErB80M6OQtNm9koQ2Q69DCW52w
         3DkMlPJg3sFauzx3A79DvufKvVIqLg9EUcib8=
Message-ID: <4DDEFFC0.2020001@gmail.com>
Date: Thu, 26 May 2011 18:34:56 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: no sound in current -git
References: <20110526013423.GA25226@redhat.com>	<4DDDD47C.5030504@gmail.com>	<20110526043337.GA11224@redhat.com>	<20110526051109.GA11870@redhat.com>	<4DDDF0D0.6090805@gmail.com> <BANLkTik5QWiW0Wm_oygnVSJNQXpZpdRB3w@mail.gmail.com>
In-Reply-To: <BANLkTik5QWiW0Wm_oygnVSJNQXpZpdRB3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 11:38 AM, Hugh Dickins wrote:
> On Wed, May 25, 2011 at 11:18 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 05/25/2011 10:11 PM, Dave Jones wrote:
>>>
>>> On Thu, May 26, 2011 at 12:33:38AM -0400, Dave Jones wrote:
>>>
>>>   >     >    sound over here is out as well on a macbook pro. seems gnome shell
>>>   >     >    didn't like whats being merged with the current Mainline i.g. no
>>> sound
>>>   >     >    bluetooth applet missing. will bisect when I get a chance.
>>>   >
>>>   >    Maybe it was this that just got merged..  (building now)
>>>   >
>>>   >    commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
>>>   >    Author: Eric Paris<eparis@redhat.com>
>>>   >    Date:   Wed May 25 19:49:18 2011 -0700
>>>   >
>>>   >        tmpfs: fix XATTR N overriding POSIX_ACL Y
>>>
>>> Yep. That fixes sound for me.
>>> Sorry for the false alarm Takashi!
>>>
>>>         Dave
>>>
>>>
>>
>> hmm.. pulled and noticed the above with git log, then did git revert for the
>> above, built, but still no sound. will do a bisect in the morning or later
>> on.
>
> That commit was the fix, not the origin of the bug, so reverting it
> was not the right thing to do!
>
> But it's only a fix if your .config has not yet been messed up (with
> CONFIG_TMPFS_XATTR and CONFIG_TMPFS_POSIX_ACL unset, though used
> somewhere for sound).
>
> So, just delete the CONFIG_TMPFS_XATTR and CONFIG_TMPFS_POSIX_ACL
> lines from your .config (perhaps you don't even get an ACL line if the
> XATTR is not set, I forget) and run "make oldconfig", this time
> choosing Y.
>
> If this was your sound problem too, then the rebuilt kernel should fix it.
>
> Apologies for inflicting this on people: Linus spotted it and got it
> fixed up a.s.a.p so it only would only affect those who pulled a tree
> yesterday.
>
> Hugh
>


alright.. sound is up and running over here with the latest. seems I 
needed to do a git clean -fx and rebuild for this to work correctly.

cheers,

Justin P, Mattock
