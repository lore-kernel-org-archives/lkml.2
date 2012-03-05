Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2CEMs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:48:29 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64270 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab2CEMs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:48:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.11.19 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F54B618.1090301@suse.cz>
Date: Mon, 05 Mar 2012 13:48:24 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20120305120241.GA3627@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 01:02 PM, Heiko Carstens wrote:
> On Mon, Mar 05, 2012 at 12:32:58PM +0100, Jiri Slaby wrote:
>> Perhaps asm/compat.h should be included from linux/compat.h
>> unconditionally...
> 
> If you do that you need to add #ifdef wrappers around the is_compat_task()
> definitions in each arch that supports CONFIG_COMPAT. If that's all that's
> needed that would be great!

I don't know, I haven't checked. It was just a shot in the dark. Maybe
it's easier to revert the removal of asm/compat.h from s390 files. Could
you bake a patch?

>>> Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT
>>
>> But who defines is_compat_task *with* CONFIG_COMPAT on ia64?
>>
>> fs/autofs4/inode.c: In function 'autofs4_fill_super':
>> fs/autofs4/inode.c:345: error: implicit declaration of function
>> 'is_compat_task'
> 
> The ia64 compat code got entirely removed, since it was broken:
> 
> 32974ad4907cdde6c9de612cd1b2ee0568fb9409 "[IA64] Remove COMPAT_IA32 support"

Yes, but that is even in 2.6.34. So the fix for autofs is incomplete in
.32 as it breaks build on configs which used to work.

thanks,
-- 
js
suse labs
