Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1DLUeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:34:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757145Ab1DLUeg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <4DA4B3FE.2080609@redhat.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
 <20110412190934.GA12082@redhat.com> <4DA4B3FE.2080609@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Apr 2011 13:33:44 -0700
Message-ID: <BANLkTi=6M60z4bvnbgFSGFSTgH0HrLuQ9A@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Karel Zak <kzak@redhat.com>, Ram Pai <linuxram@us.ibm.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 1:20 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>
> so it's supposed to be like this, from Documentation/filesystems/proc.txt:
>
>> This file contains lines of the form:
>>
>> 36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 /dev/root rw,errors=continue
>> (1)(2)(3)   (4)   (5)      (6)      (7)   (8) (9)   (10)         (11)

Gaah, yes. Apparently that placement is correct and documented, and
has been since the beginning.

However, reality always takes precedence, so I think that for now
we'll just have to revert the commit that added the uid: tag, and we
can re-visit this issue when hopefully the tools have been fixed.

"But it's documented.." sadly doesn't fix actual user installations or
user-visible regressions.

                          Linus
