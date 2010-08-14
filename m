Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0HNPKi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 11:10:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37295 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0HNPKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 11:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p1N9T9mkYs5fstiCFjp2qGjG3hdqYjfBmUK1yJ0DtGxGq0gIOojIRGQZkvsJeK93x8
         3DSSAj3CBYosC7PpSX3u/KrLVyL/t3iAnirFSBhzLYx2D/iXW+GCmD6gmY6yOUe1EbES
         8xb8Gm4OhSq4iYDix15F4/wSIiD0+uX7czO14=
MIME-Version: 1.0
In-Reply-To: <59961099b1fbdb3e827d3c9f9bed3532@linux.psw.ro>
References: <20100813212313.GA22102@kroah.com>
	<a00737cba20cb46512a2248e0477cc0b@linux.psw.ro>
	<AANLkTi=YfKZkE6ee6rE9LvtAiQ6F0YaTHbN+O_dTGHKb@mail.gmail.com>
	<20100814133942.GA17430@suse.de>
	<59961099b1fbdb3e827d3c9f9bed3532@linux.psw.ro>
Date: Sat, 14 Aug 2010 17:10:36 +0200
Message-ID: <AANLkTimSuqd_5YG3b9aUDmTaQQskhQBbS2_aerBzjsHQ@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
From: Bjarke Istrup Pedersen <gurligebis@gmail.com>
To: Arthur Titeica <arthur@psw.ro>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/14 Arthur Titeica <arthur@psw.ro>:
> On Sat, 14 Aug 2010 06:39:42 -0700, Greg KH <gregkh@suse.de> wrote:
>> On Sat, Aug 14, 2010 at 02:21:31PM +0300, Pekka Enberg wrote:
>>> On Sat, Aug 14, 2010 at 1:35 PM, Arthur Titeica <arthur@psw.ro> wrote:
>>> > On Fri, 13 Aug 2010 14:23:13 -0700, Greg KH <gregkh@suse.de> wrote:
>>> >> I'm announcing the release of the 2.6.35.2 kernel.
>>> >>
>>> >> All users of the 2.6.35 kernel series must upgrade.
>>> >>
>>> >
>>> > I'm not sure this is the right mailing list but this is the first
>>> > kernel that fails to boot for me (since 2.6.33.x).
>>> >
>>> > The laptop just restarts right after "Freeing unused kernel memory:
>>> > 628k freed"
>>> >
>>> > 2.6.35.1 is fine with the same .config.
>>> >
>>> > Anyone willing to help me to debug?
>>>
>>> You could try 'git bisect' between v2.6.35.1 and v2.6.35.2 to narrow
>>> the problem down to a specific commit.
>>
>> Yes, if you could please do that, it would be most appreciated.
>>
> I'm trying but I'm not even close to a dev and anything beyond 'git
> pull' looks tricky.
>
> I've gotten so far:
>
> $ git bisect start
> $ git bisect bad
> $ git bisect good v2.6.35.1
> fatal: Needed a single revision
> Bad rev input: v2.6.35.1
> $ git bisect good v2.6.35
> Bisecting: 3941 revisions left to test after this (roughly 12 steps)
> [2192482ee5ce5d5d4a6cec0c351b2d3a744606eb] Merge branch 'for-rmk' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
> devel-stable
>
> What next? ;)
>

Build your kernel, and see if it boots.
If it boots, run: git bisect good
If it doesn't boot, run: git bisect bad

Repeat the process until it is done (should be close to 12 times).
When it is done, it will tell you which commit is the one that breaks booting.

>
> --
> Arthur Titeica
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
