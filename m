Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036Ab1HIN1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 09:27:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:62306 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1HIN1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 09:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110805212153.GL5782@one.firstfloor.org>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Aug 2011 09:26:55 -0400
X-Google-Sender-Auth: 39VbEoSJfKtdoC08n8n7Lzv6xNg
Message-ID: <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
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
>
> But really serious binary incompatibility like this should not be default
> (not even talking about the slow down for existing binaries using time())

Why do we care about pin again?

$ ./pin -t obj-intel64/opcodemix.so -- /bin/ls
E:3.0 is not a supported linux release

So we've already broken it completely, and they'll have to release a
new version anyway to fix it.  This version is from June of this year.

I'll send out the updated patch anyway for the benefit of DynamoRIO
(which is the only thing I know of that is affected).

--Andy
