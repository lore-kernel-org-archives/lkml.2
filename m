Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0HPMfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:35:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44733 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab0HPMfB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:35:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F17+e1IrX2jCVtITnLAbz2qUH3eB3tFkZ2IFQdEiuHFxuDV/1SWRqyLfPivZuCc5bd
         GklH3mR/LS2LLxltwgC9UJ+B5GgYGH2DAgCXT/VvcTN+xZ4zdv8Mx13tfBmpC4uVrXj9
         xN8ILJd4vRQdJxLasMsDyTovHh8fTI3go1vNo=
MIME-Version: 1.0
In-Reply-To: <4C613627.1090907@suse.cz>
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
	<20100621120613.86cad1a4.akpm@linux-foundation.org>
	<4C1FC35C.8090201@suse.cz>
	<AANLkTil2-YNAa-jyOYD4cNtbJQ1XQJ6-v3iJ6wxpz7br@mail.gmail.com>
	<AANLkTinC6Sqs7W--=14nmJFDcTS4HQn0=ysn7VhYDDX6@mail.gmail.com>
	<adaocdg3fng.fsf@roland-alpha.cisco.com>
	<20100805222623.39A3240208@magilla.sf.frob.com>
	<AANLkTikvRqTR6TjP9H4-_RHhax24YRPv9PCxn165RTWs@mail.gmail.com>
	<4C613627.1090907@suse.cz>
Date: Mon, 16 Aug 2010 22:35:00 +1000
Message-ID: <AANLkTimncLdNZCcpcEi9M7-jCuw5FE+xDT7v5--ByfMn@mail.gmail.com>
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
        Roland McGrath <roland@redhat.com>, Roland Dreier <rdreier@cisco.com>,
        Tiago Maluta <tiago.maluta@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gives some errors on my ubuntu build for -rc1, reverting lets it
build normally. Am I missing something?

ahendry@ubuntu:~/linux/linux-2.6$ make
make: ngcc: Command not found
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s
/bin/sh: ngcc: not found
make[1]: *** [kernel/bounds.s] Error 127
make: *** [prepare0] Error 2

.config has CONFIG_CROSS_COMPILE="n"

On Tue, Aug 10, 2010 at 9:21 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 10.8.2010 08:43, Yegor Yefremov wrote:
>> On Fri, Aug 6, 2010 at 12:26 AM, Roland McGrath <roland@redhat.com> wrote:
>>>> Yes, this make sense to me.  It's not clear to me why we ever needed
>>>> the conditional assignment of an empty CROSS_COMPILE (that code predates
>>>> the start of git history) [...]
>>>
>>> Perhaps someone used make --warn-undefined-variables.
>>
>> Are there any other comments or is the patch valid? Should I resend it
>> as a new thread?
>
> No problem at your side, the patch is fine and I applied it now.
>
> Michal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
