Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab1CCS34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 13:29:56 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:6339 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133Ab1CCS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 13:29:55 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAG9tb01Ld/sX/2dsb2JhbAAMhB3QdpEWgSeDRHYEhRo
X-IronPort-AV: E=Sophos;i="4.62,259,1297054800"; 
   d="scan'208";a="94288985"
Message-ID: <4D6FDE21.7000303@teksavvy.com>
Date: Thu, 03 Mar 2011 13:29:53 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.14) Gecko/20110221 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ken Sumrall <ksumrall@android.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <matthew@wil.cx>,
        Eric Paris <eparis@redhat.com>, Dave Young <hidave.darkstar@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Syscalls: reboot: Add options to the reboot syscall to
 remount filesystems ro
References: <1299137483-10975-1-git-send-email-ksumrall@android.com> <AANLkTik1pNPzPqXaNrLNFnEt4+cknxYdOUwZ9Q=g5PCA@mail.gmail.com> <AANLkTi=z0gHbrGPUZ+vvNPGrOzGowBuWjMUEZpqS+ZCc@mail.gmail.com>
In-Reply-To: <AANLkTi=z0gHbrGPUZ+vvNPGrOzGowBuWjMUEZpqS+ZCc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-03 01:17 PM, Linus Torvalds wrote:
> On Thu, Mar 3, 2011 at 9:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> How many mounted filesystems do you have that it's so hard to keep track of?
> 
> Btw, /proc/mounts will track them for you even if you don't have a
> 'mount' binary that does.
> 
> Parsing that is pretty trivial. If you have spaces or special
> characters in your pathnames (you may control the mount paths, you may
> not - I have no idea), you'll need to be able to handle the escape
> format (\oct). But other than that, it's literally just
> 
>  - read all of /proc/mounts into a buffer
> 
>  - for each line, split by space, and you'll have the directory name
> right there in the second field
> 
>  - do the unescaping ("\oct" -> character) if needed. It's good
> practice. Test it.
> 
>  - just do a read-only remount on it.
> 
> All done. No kernel changes necessary. It just works.


This might be much less complex:

   #!/bin/sh
   echo s > /proc/sysrq-trigger
   echo u > /proc/sysrq-trigger

