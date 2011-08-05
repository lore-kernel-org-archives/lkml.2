Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1HEV0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:26:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46803 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab1HEV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:26:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110805212153.GL5782@one.firstfloor.org>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 5 Aug 2011 17:26:18 -0400
X-Google-Sender-Auth: b987xvV0VwiLuNx0kmxxu4M6nNY
Message-ID: <CAObL_7GuauANLqM9DnbYnhRuOsnqE+fTEoM10qCfjc40eFHaUA@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 5, 2011 at 5:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Aug 05, 2011 at 05:00:44PM -0400, Andrew Lutomirski wrote:
>> > If anything runtime, but really for me it looks like the vsyscall
>> > changes should be only in one of those limited compability paranoia
>> > patchkits.
>>
>> Switching it in runtime would be a giant mess because user code might
>
> You can always switch at boot time.

For a boot time switch, it might be nicer to just switch between the
current int 0xcc sequence and the older

mov cx, 0x<magic>
int 0xcc
ret

sequence.

That way there's a ret in the vsyscall page but no syscall instruction.

--Andy
