Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab1HEFn3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:43:29 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36614 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754708Ab1HEFn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:43:28 -0400
Message-ID: <4E3B82FD.1040500@xenotime.net>
Date: Thu, 04 Aug 2011 22:43:25 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] drivers/base/inode.c: let vmstat_text be optional
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au> <20110804152211.ea10e3e7.rdunlap@xenotime.net> <4E3B57C3.80203@redhat.com>
In-Reply-To: <4E3B57C3.80203@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/11 19:38, Cong Wang wrote:
> 于 2011年08月05日 06:22, Randy Dunlap 写道:
>> From: Randy Dunlap<rdunlap@xenotime.net>
>>
>> vmstat_text is only available when PROC_FS or SYSFS is enabled.
>> This causes build errors in drivers/base/node.c when they are
>> both disabled:
>>
>> drivers/built-in.o: In function `node_read_vmstat':
>> node.c:(.text+0x10e28f): undefined reference to `vmstat_text'
>>
>> Rather than litter drivers/base/node.c with #ifdef/#endif around
>> the affected lines of code, add macros for optional sysdev
>> attributes so that those lines of code will be ignored, without
>> using #ifdef/#endif in the .c file(s).  I.e., the ifdeffery
>> is done only in a header file with sysdev_create_file_optional()
>> and sysdev_remove_file_optional().
>>
> 
> This looks ugly for me, because other sysfs files here are not optional
> only due to that they don't rely on vmstat_text.
> 
> I still think my approach to fix this is better, that is, introducing
> a new Kconfig for drivers/base/node.c which depends on CONFIG_SYSFS.

Did you post a patch for that?  I must have missed it.

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
