Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab1DJRQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 13:16:03 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41799 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab1DJRP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 13:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ShVW32tpsFURdEAXxiFl7gVjK+7WeZmBlGqGbRE1Ywnt5Uv+wO+I0ce26H7S1/XbH2
         1m4/Hb6dPoHlVp8IUKrZT20UfO5UhmzsZMhzGt7aK3lsS2nOzlNJHARgtkPgr77luT9s
         RHjdHi0BNvBJNiBmJUZIu4x4C7jNWme7z4w2Y=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
References: <BANLkTi=n+ckDXVk6rN=Mgh+BApbrPqPfmg@mail.gmail.com>
Date: Sun, 10 Apr 2011 19:15:58 +0200
Message-ID: <BANLkTikVMsKW9Hojo8CAu6w0PNrxUdoz=Q@mail.gmail.com>
Subject: Re: Crash with kfree(null) on MacBook? kobject_set_name_vargs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Botting <andy@andybotting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 10 kwietnia 2011 19:14 użytkownik Rafał Miłecki
<zajec5@gmail.com> napisał:
> I'm writing new axi bus driver and one of the early testers reported
> it crashing for him. Andy is using MacBook and backtrace+debugging
> pretty clearly point to kfree being called on null string.
>
> The most interesting part of code is:
> axi_info("[axi_register_cores][%d] current name: %s\n", i, core->dev.kobj.name);
> axi_info("[axi_register_cores][%d] calling dev_set_name with %d, %d
> for 0x%03X\n", i, 0/*bus->busnumber*/, dev_id, core->id.id);
> err = dev_set_name(&core->dev, "axi%d:%d", 0/*bus->busnumber*/, dev_id);
> axi_info("[axi_register_cores][%d] dev_set_name result: %d\n", i, err);
>
> The result is:
> [axi_register_cores][1] current name: (null)
> [axi_register_cores][1] calling dev_set_name with 0, 0 for 0x812
> BUG: unable to handle kernel paging request at ffffeba400000000
> IP: [<ffffffff8108c4d4>] kfree+0x2a/0x8a
>
> Whole code: http://pastie.org/1779473
> Whole result: http://pastie.org/1779416
>
> Can you help me with this issue, please? On my machine everything goes fine:
> [axi_register_cores][1] current name: (null)
> [axi_register_cores][1] calling dev_set_name with 0, 0 for 0x812
> [axi_register_cores][1] dev_set_name result: 0
> [axi_register_cores][1] Register dev for core 0x812
>
> bcopeland on #linux-wireless suggested turning on SLAB or SLUB. Is
> this going to provide some interesting info?

Link to kobject_set_name_vargs for lazy ;)
http://lxr.free-electrons.com/source/lib/kobject.c#L215

-- 
Rafał
