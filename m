Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab1LGAJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:09:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56461 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1LGAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:09:20 -0500
Message-ID: <4EDEAEA7.9060806@canonical.com>
Date: Tue, 06 Dec 2011 16:09:11 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] apparmor fix for __d_path() misuse
References: <20111206154854.GH2203@ZenIV.linux.org.uk> <CA+55aFybiSeYk57DdWXVWJvDk0VTU2hUtJWZUMaBdWOxYtdd_w@mail.gmail.com> <20111206205346.GK2203@ZenIV.linux.org.uk> <CA+55aFwbWUBs3Fy1hyP3CQ15rF2opvjxLR8gnSF5gERDGCGhOw@mail.gmail.com> <4EDE94DC.8010106@canonical.com> <20111206224100.GM2203@ZenIV.linux.org.uk> <4EDEA152.90804@canonical.com> <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
In-Reply-To: <CA+55aFwn=n5H_PuaRhnVPpMtfeig8nSi+Wj4Yzv6VBdjkUBEjw@mail.gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 03:45 PM, Linus Torvalds wrote:
> On Tue, Dec 6, 2011 at 3:12 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>>
>> What we want to know is if we missed the supplied root, so that we don't
>> mediate off of that path.  And it would be nice to get a partial path for
>> the purposes of logging, so that there is some guidance on how to update
>> policy.
> 
> How about this change:
>  - don't change 'root' (and mark it const)
>  - if we hit the expected root, we're all happy and do what we do now
>  - if we hit some *unexpected* root (the "global root") add a '?' or
> something at the head of the path.
> 
> End result: callers like getcwd() can trivially replace their current
> "path_equal(&tmp,&root)" (or whatever they do) with just checking the
> first character of the end result. A good path always starts with '/'.
> 
> Something kind of like this (this does *not* change apparmor or tomoyo
> - I didn't even look at those uses).
> 
yes this would give apparmor what it needs.  We would still have to break
one chroot case, until our labeling is properly updated.  But its insane
to plan the api around that case as it is hardly used and a proper solution
for that case is in the works.

