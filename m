Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1FOPtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:49:41 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40125 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab1FOPtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NIUOf90RSyYqw2/rAyLRllZ0QBQTdk8Yr0vIFtqSIZJMgz0WO64AFYZ/DveTYxaxrR
         dnjJaQwI1vEZEelpioUWVpHgJDcXGgnxYKpvxiD1Tkc5p6enwm/wTyBs/uBZE5BCdLq5
         5KLUlQe440sYhcdmXJvPWFM0e9QB0WlgxH6mA=
MIME-Version: 1.0
In-Reply-To: <BANLkTin214-RYxJUQ-uM6iYz1NQLBKRH2Q@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
	<1307642718-22257-1-git-send-email-minipli@googlemail.com>
	<20110609155630.0f734351.akpm@linux-foundation.org>
	<BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
	<1307711394-7827-1-git-send-email-minipli@googlemail.com>
	<BANLkTin214-RYxJUQ-uM6iYz1NQLBKRH2Q@mail.gmail.com>
Date: Wed, 15 Jun 2011 17:49:39 +0200
Message-ID: <BANLkTikdD8rwUhEXzkgj5qEN7a3E=BoDgQ@mail.gmail.com>
Subject: Re: [PATCH] m68k, exec: remove redundant set_fs(USER_DS)
From: Mathias Krause <minipli@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 4:40 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Jun 10, 2011 at 15:09, Mathias Krause <minipli@googlemail.com> wrote:
>> The address limit is already set in flush_old_exec() so those calls to
>> set_fs(USER_DS) are redundant.
>>
>> Signed-off-by: Mathias Krause <minipli@googlemail.com>
>> Cc: Greg Ungerer <gerg@uclinux.org>
>> ---
>>
>> Note: I'm not sure about the assignment to current->thread.fs in
>> flush_thread() -- shouldn't this be done in set_fs() itself?
>
> set_fs() is used to temporary set the address space to be used from the
> kernel.
> current->thread.fs is the address space that will be used when the
> thread returns
> to userspace.
> So I think it's correct.
>
> For nommu, thread.fs is set, but not really used.

Thanks for the explanation. So only the set_fs() is redundant.

Mathias
