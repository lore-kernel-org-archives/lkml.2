Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054Ab1FGCjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 22:39:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45630 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab1FGCjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 22:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZN7WRNNBfUqeRmUICqZ07YriWdmBp6wUrT1+FSjthk4dMKFwz5RCk6NBkXMLo47hP8
         +uZ8P0wvYqLbRVNCgD3IpklHxrAnH3snMBsI2HW/u5M5SBwLpKx4GLkojwWIFwQNX7Wj
         pUprCqhUeb2zPSYL1JKbrkHOQEbayDPY3PAXU=
MIME-Version: 1.0
In-Reply-To: <20110606221101.GC1999@leaf>
References: <20110605082100.GA18151@leaf>
	<4DECB261.5090109@linux.vnet.ibm.com>
	<20110606221101.GC1999@leaf>
Date: Tue, 7 Jun 2011 10:39:34 +0800
Message-ID: <BANLkTin8R8hATMQMV50WRNWjKM2sfHuK5g@mail.gmail.com>
Subject: Re: [PATCH] Disable CONFIG_CONSTRUCTORS when not needed by CONFIG_GCOV_KERNEL
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Jeff Dike <jdike@addtoit.com>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@sun.com>,
        Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 6:11 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Mon, Jun 06, 2011 at 12:56:33PM +0200, Peter Oberparleiter wrote:
>> On 05.06.2011 10:21, Josh Triplett wrote:
>> >CONFIG_CONSTRUCTORS controls support for running constructor functions
>> >at kernel init time.  According to commit
>> >b99b87f70c7785ab1e253c6220f4b0b57ce3a7f7, gcov (CONFIG_GCOV_KERNEL)
>> >needs this.  However, CONFIG_CONSTRUCTORS currently defaults to y, with
>> >no option to disable it, and CONFIG_GCOV_KERNEL depends on it.  Instead,
>> >default it to n and have CONFIG_GCOV_KERNEL select it, so that the
>> >normal case of CONFIG_GCOV_KERNEL=n will result in
>> >CONFIG_CONSTRUCTORS=n.
>> >
>> >Observed in the short list of =y values in a minimal kernel
>> >configuration.
>> >
>> >Signed-off-by: Josh Triplett<josh@joshtriplett.org>
>> >---
>>
>> I tested this patch and GCOV profiling still works with it applied.
>> To my knowledge, GCOV profiling is the only kernel mechanism using
>> GCC's constructors and this may save some bytes.
>>
>> Acked-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
>
> Excellent, thanks for testing and acking.
>
> What tree should this patch go through?
>

Andrew is supposed to take this. :)
