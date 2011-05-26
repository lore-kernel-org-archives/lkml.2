Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab1EZSiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:38:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1EZSix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=asQpdgqKbg+0pj0SdeE7wIVSXldGR4POyCJoAjH4HP2UHP+yIODP+xPVLXPQdhBT3R
         LHr+4LlTfoueIjaR98ZA==
MIME-Version: 1.0
In-Reply-To: <4DDDF0D0.6090805@gmail.com>
References: <20110526013423.GA25226@redhat.com>
	<4DDDD47C.5030504@gmail.com>
	<20110526043337.GA11224@redhat.com>
	<20110526051109.GA11870@redhat.com>
	<4DDDF0D0.6090805@gmail.com>
Date: Thu, 26 May 2011 11:38:50 -0700
Message-ID: <BANLkTik5QWiW0Wm_oygnVSJNQXpZpdRB3w@mail.gmail.com>
Subject: Re: no sound in current -git
From: Hugh Dickins <hughd@google.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:18 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> On 05/25/2011 10:11 PM, Dave Jones wrote:
>>
>> On Thu, May 26, 2011 at 12:33:38AM -0400, Dave Jones wrote:
>>
>>  >   >  sound over here is out as well on a macbook pro. seems gnome shell
>>  >   >  didn't like whats being merged with the current Mainline i.g. no
>> sound
>>  >   >  bluetooth applet missing. will bisect when I get a chance.
>>  >
>>  >  Maybe it was this that just got merged..  (building now)
>>  >
>>  >  commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5
>>  >  Author: Eric Paris<eparis@redhat.com>
>>  >  Date:   Wed May 25 19:49:18 2011 -0700
>>  >
>>  >      tmpfs: fix XATTR N overriding POSIX_ACL Y
>>
>> Yep. That fixes sound for me.
>> Sorry for the false alarm Takashi!
>>
>>        Dave
>>
>>
>
> hmm.. pulled and noticed the above with git log, then did git revert for the
> above, built, but still no sound. will do a bisect in the morning or later
> on.

That commit was the fix, not the origin of the bug, so reverting it
was not the right thing to do!

But it's only a fix if your .config has not yet been messed up (with
CONFIG_TMPFS_XATTR and CONFIG_TMPFS_POSIX_ACL unset, though used
somewhere for sound).

So, just delete the CONFIG_TMPFS_XATTR and CONFIG_TMPFS_POSIX_ACL
lines from your .config (perhaps you don't even get an ACL line if the
XATTR is not set, I forget) and run "make oldconfig", this time
choosing Y.

If this was your sound problem too, then the rebuilt kernel should fix it.

Apologies for inflicting this on people: Linus spotted it and got it
fixed up a.s.a.p so it only would only affect those who pulled a tree
yesterday.

Hugh
