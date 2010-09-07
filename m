Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab0IGSe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:34:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55693 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0IGSe0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jjHjGOfbkgTT6dv/U/CPruhOyXYUTSx3ZxbKjTz8sCZol3pBHV7OeImTANGjuhBLzL
         pTYJzqJHcFSsP9VIGdx6utp80Cma9yH9R3fe3gP0TJs++k4UK2+MmsJM3EKwrr6ohQbt
         Gv5vMBK757cPbzlr8U5o/a7BD2dZJYiW8ZwNg=
MIME-Version: 1.0
In-Reply-To: <201009071635.11110.Martin@lichtvoll.de>
References: <201009071635.11110.Martin@lichtvoll.de>
Date: Tue, 7 Sep 2010 14:34:25 -0400
Message-ID: <AANLkTi=o7f9_u9BpJ2ORA-WSv5YV_H5hZSMbLzN+g0TF@mail.gmail.com>
Subject: Re: Bisecting radeon kms freeze bug: Almost there, please help with
 choosing next commit
From: Alex Deucher <alexdeucher@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 10:34 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> Hello Alex and und Dave,
>
> please excuse typing errors. The machine is abysmally slow with that
> kernel.
>
> I am almost there with bisecting Bug 16376, random - possibly Radeon DRM
> KM related - freezes. I think I found the merge where is issue has been
> introduced and I am now testing
>
> martin@shambhala:~/Computer/Shambhala/Kernel/2.6.33-2.6.34-
> bisect/linux-2.6> git log | head
> commit 6ad86c311a8b8a6d856527a1b6ba21790ab7054b
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Thu Feb 11 10:47:52 2010 -0500
>
>    drm/radeon/kms: remove HDP flushes from fence emit (v2)
>
>    r600_ioctl_wait_idle() now handles this.
>
>    v2: update blit fence counts
>
> Unfortunately it has some other issues that has been fixed later on prior
> to 2.6.34 already:
>
> 7.9.2010 - 2.6.32-tp42-00514-g6ad86c3
> 6ad86c311a8b8a6d856527a1b6ba21790ab7054b
> - Sluggy desktop. Short pauses, locks of about a second.
> - Slow scroll performance on tty.
> - No complete freeze yet.
> - Much CPU time used in system:70-90%
>
> You know the changes in that merge better than me. Can you recommend which
> commits to test next? Som commits may require other ones and thus it might
> be wise to choose the next commits with that in mind. Maybe you already
> have an idea which one it could be. I thought about the memory controllr
> v2 changes, but I really don't have the foggiest.

This might be a duplicate of:
https://bugs.freedesktop.org/show_bug.cgi?id=28402
Does the patch there help?

Alex

>
>
> Here is excerpt from atop which shows ridicully high system CPU usage with
> that kernel.
>
> ATOP - shambhala          2010/09/07  16:11:22               10 seconds
> elapsed
> PRC | sys   8.66s | user   1.30s | #proc    195 | #zombie    0 | #exit
> 0 |
> CPU | sys     85% | user     11% | irq       4% | idle      0% | wait
> 0% |
> CPL | avg1   3.39 | avg5    3.80 | avg15   3.25 | csw    18458 | intr
> 11472 |
> MEM | tot    2.0G | free  543.1M | cache 759.6M | buff   95.0M | slab
> 37.8M |
> SWP | tot    3.8G | free    3.8G |              | vmcom   1.3G | vmlim
> 4.8G |
> DSK |         sda | busy      3% | read       1 | write     95 | avio    2
> ms |
>
> I wrote by mail since bugzilla has too many MySQL connections again. Maybe
> bug can be switched to mail?
>
> Rebooting and testing this kernel another time whether it hard freezes,
> --
> Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
> GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
>
