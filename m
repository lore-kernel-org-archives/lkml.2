Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab1HNTQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 15:16:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49266 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1HNTQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 15:16:33 -0400
Message-ID: <4E481F0D.3090404@landley.net>
Date: Sun, 14 Aug 2011 14:16:29 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>,
        busybox@busybox.net
Subject: Re: [BUG] Linux 3.0 commit 3627924acf70a broke include/mtd/ubi_user.h.
References: <4E4809BF.6040707@landley.net> <20110814200322.3fa7109d@stein>
In-Reply-To: <20110814200322.3fa7109d@stein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2011 01:03 PM, Stefan Richter wrote:
> On Aug 14 Rob Landley wrote:
>> "make headers_install" copies include/mtd/ubi_user.h to userspace, where
>> things like busybox link against it.  With 3.0, building defconfig
>> busybox gets this error:
>>
>> In file included from miscutils/ubi_tools.c:63:
>> /home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:329:
>> error: conflicting types for '__packed'
>> /home/landley/aboriginal/aboriginal/build/simple-cross-compiler-i686/bin/../include/mtd/ubi-user.h:313:
>> error: previous declaration of '__packed' was here
>>
>> This is due to the Linux 3.0 commit in the title:
>>
>>     UBI: use __packed instead of __attribute__((packed))
>>
>> This relies on __packed being defined in:
>>
>>   include/linux/compiler-gcc.h:
>>   #define __packed			__attribute__((packed))
>>
>> Which is not exported to userspace.
>>
>> I.E. this "cleanup" broke the ability for userspace to use this header,
>> even though the header is exported to userspace by headers_install.
> 
> As far as I can tell, the __packed or __attribute__((packed))
> qualifications are superfluous in include/mtd/ubi-user.h anyway.

And Adrian Hunter <adrian.hunter@nokia.com> (the other listed UBI
maintainer) also bounces.  Did the developer exodus after Nokia decided
to cozy up to The Black Widow take 'em both out?

Rob
