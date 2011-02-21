Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1BUOFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:05:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56939 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab1BUOFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:05:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SUjqSvpBOfRbInyr5M6uJdF+qbtb8NbrMfe4ufMxI+mhMM5RsZFqidvo69PfUG7wlh
         LOPcPibVD1kgYtnzDR1LzknqXyWJ6PC9PupkpIPwNp+TCz09oduO9rStIT2v6HkIJ9YU
         8CDLcyzm60/GGsp81DvtFXVcx26D4YvTRaC+0=
MIME-Version: 1.0
In-Reply-To: <20110221135709.GG23087@legolas.emea.dhcp.ti.com>
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
	<1298283649-24532-2-git-send-email-dacohen@gmail.com>
	<AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
	<20110221123049.GC23087@legolas.emea.dhcp.ti.com>
	<AANLkTinc=ye2qZJ1esSta=xEGz_iEr73eg3qEES2S5P7@mail.gmail.com>
	<20110221135709.GG23087@legolas.emea.dhcp.ti.com>
Date: Mon, 21 Feb 2011 16:05:14 +0200
Message-ID: <AANLkTin6SY6oUd8j3dcvjoTrPn4P2XP=hX5S+D8s1J+g@mail.gmail.com>
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: David Cohen <dacohen@gmail.com>
To: balbi@ti.com
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 3:57 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Feb 21, 2011 at 03:51:25PM +0200, Alexey Dobriyan wrote:
>> > I rather have the split done and kill the circular dependency.
>>
>> It's not circular for starters.
>
> how come ? wait.h depends on sched and sched.h depends on wait.h

The tricky thing is wait.h doesn't depend on sched.h, but the file
which uses wake_up*() macro defined on wait.h will depend on sched.h
(what is still bad). wait.h should provide all dependencies to use a
macro it defines. I'll send a new version for this patch following the
comments I got. Let's see how it looks like.

Br,

David

>
> --
> balbi
>
