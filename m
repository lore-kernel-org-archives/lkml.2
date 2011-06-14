Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab1FNMQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:16:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55492 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1FNMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=W2CYmurfI9ZWKGECxEJTv9LJq0BDg3JdlByrMku4ZIY78OYLWA+R7lOutt4W1BPtiy
         uceOvSgKdZlaccWny9mJ6e38YkiHH2U2Mi7YOxe/7Hpe22aFkMHqTBSHDwkBVhMz1OQw
         VmP1A48p0zuMAEUN6c00H5Eldqgxvv9I3DMaA=
MIME-Version: 1.0
In-Reply-To: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Tue, 14 Jun 2011 14:15:37 +0200
Message-ID: <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
Subject: Re: Linux 3.0-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 1:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> .. and this time even with a timely tar-ball, since I'm not traveling any more.
>
> What do we have in it? More than in -rc2. I'm clearly not the only one
> who was in Japan for LinuxCon, or something else just made people wake
> up.

Linus, I know I run a risk of being not the first person to ask this,
but anyway.

I've got a patch for my project to fix parsing of kernel version which
has only two numbers. Basically,

- scanf(ver, "%u.%u.%u", &a, &b, &c)
+ sscanf(ver, "%u.%u", &a, &b)

I can take it, but it made me thinking: how many other projects
will be similarly affected? Must be hundreds, even thousands.

I propose to still use three digits. I mean, if you want to use
3.0, 3.1, 3.2 numbering for your releases and leave third digit
for stable series, just number them 3.0.0, 3.1.0, 3.2.0 instead.

This way, many userspace projects will need less patching
in order to work with 3.x. In many cases, they can
avoid patching altogether.

-- 
vda
