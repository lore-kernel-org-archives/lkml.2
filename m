Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0HVNrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 09:47:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55747 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0HVNr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 09:47:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cHEQJcFm5jVRtEOiPrq2nSF6PSFFUM28unqryy0x8Cksnc8gVycMHAuD60fbZ3EEXF
         Xkfz2ZKF8SJTRm6R7C3a2ecpoA5V19mtS+PT2WFShuGT5EKQKHn716xVWsYVbbCwwdmD
         S9w/CARr+VQy4vHOmhOmsUDEoa4yFk01AYxig=
MIME-Version: 1.0
In-Reply-To: <201008221507.42023.arnd@arndb.de>
References: <1282475544-24708-1-git-send-email-xiaosuo@gmail.com>
 <AANLkTin1BOgHBc4sTwFAmQhKFNvZ+90herc4Dsh9P8y2@mail.gmail.com> <201008221507.42023.arnd@arndb.de>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 22 Aug 2010 21:47:06 +0800
Message-ID: <AANLkTiktOcAvAxcXUxh+4jKh0nBmYCf0OVG0wqRNMb9T@mail.gmail.com>
Subject: Re: [PATCH] net: define __packed for the userspace code
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 9:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Sunday 22 August 2010 13:23:42 Changli Gao wrote:
>> On Sun, Aug 22, 2010 at 7:12 PM, Changli Gao <xiaosuo@gmail.com> wrote:
>> > This commit
>> >
>> >  commit bc10502dba37d3b210efd9f3867212298f13b78e
>> >  Author: Eric Dumazet <eric.dumazet@gmail.com>
>> >  Date:   Thu Jun 3 03:21:52 2010 -0700
>> >
>> >    net: use __packed annotation
>> >
>> > makes use of __packed in the userspace code. So we'd better define __packed
>> > for the userspace code too.
>> >
>>
>> Oh, sorry. This patch can't work as include/linux/compiler.h isn't
>> exported to the userspace. But where should we define __packed for the
>> userspace code? include/linux/types.h?
>
> I would try to avoid making those structures packed to start with.
> From what I can see, they structures annotated in the above commit
> mostly don't even require explicit packing because they are already
> packed. Not marking them packed makes the code portable to non-gcc
> compilers.
>

Maybe __packed is used somewhere to hint that some members of a
structure maybe unaligned.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
