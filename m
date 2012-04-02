Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab2DBTLg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:11:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:57646 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2DBTLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:11:33 -0400
Message-ID: <4F79F9DD.9050203@windriver.com>
Date: Mon, 2 Apr 2012 15:11:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: Re: [PATCH 03/11] avr32: fix nop compile fails from system.h split
 up
References: <1333312727-11428-4-git-send-email-paul.gortmaker@windriver.com> <1333312727-11428-1-git-send-email-paul.gortmaker@windriver.com> <30076.1333345656@redhat.com>
In-Reply-To: <30076.1333345656@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-02 01:47 AM, David Howells wrote:
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> To fix:
>>
>>   In file included from kernel/exit.c:61:
>>   arch/avr32/include/asm/mmu_context.h: In function 'enable_mmu':
>>   arch/avr32/include/asm/mmu_context.h:135: error: implicit
>>   declaration of function 'nop'
> 
> Better would be to move the definition of nop() into asm/barrier.h to be
> consistent with other arches.

That does seem to make sense.  But just to confirm, then I'd end up
deleting the new file, arch/avr32/include/asm/special_insns.h

------------
commit ae473946586680b01c13975a3b674de23ad7c93e
Author: David Howells <dhowells@redhat.com>
Date:   Wed Mar 28 18:30:01 2012 +0100

    Disintegrate asm/system.h for AVR32
    
    Disintegrate asm/system.h for AVR32.  This has not been compiled at all.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    cc: Haavard Skinnemoen <hskinnemoen@gmail.com>

:000000 100644 0000000... f922218... A  arch/avr32/include/asm/special_insns.h
------------

...since it only contains the nop definition.

Is that what you had in mind, or is some other content going to
be moved there at a later time?

Thanks,
Paul.

> 
> David
