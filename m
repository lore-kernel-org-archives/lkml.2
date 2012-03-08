Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2CHLGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:06:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65399 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2CHLGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:06:33 -0500
Message-ID: <4F5892B1.3070008@suse.cz>
Date: Thu, 08 Mar 2012 12:06:25 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120229 Thunderbird/11.0
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        raven@themaw.net
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
References: <20120304180911.GA7336@kroah.com> <4F54A46A.6000305@suse.cz> <20120305120241.GA3627@osiris.boeblingen.de.ibm.com> <4F54B618.1090301@suse.cz> <20120305223338.GE2930@1wt.eu>
In-Reply-To: <20120305223338.GE2930@1wt.eu>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------090501020904000104020705"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090501020904000104020705
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 03/05/2012 11:33 PM, Willy Tarreau wrote:
> Hi,
> 
> On Mon, Mar 05, 2012 at 01:48:24PM +0100, Jiri Slaby wrote:
>>>>> Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT
>>>>
>>>> But who defines is_compat_task *with* CONFIG_COMPAT on ia64?
>>>>
>>>> fs/autofs4/inode.c: In function 'autofs4_fill_super':
>>>> fs/autofs4/inode.c:345: error: implicit declaration of function
>>>> 'is_compat_task'
>>>
>>> The ia64 compat code got entirely removed, since it was broken:
>>>
>>> 32974ad4907cdde6c9de612cd1b2ee0568fb9409 "[IA64] Remove COMPAT_IA32 support"
>>
>> Yes, but that is even in 2.6.34. So the fix for autofs is incomplete in
>> .32 as it breaks build on configs which used to work.
> 
> So in the end, does anybody have an idea what is missing from this patch ?
> I'm not sure that reverting the autofs fix is a right solution either :-/

Nobody relevant? Hmm... I use the attached patch. If there are no
objections, I will add a header there and send to Willy.

thanks,
-- 
js
suse labs

--------------090501020904000104020705
Content-Type: text/x-patch;
 name="ia64-is_compat_task-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ia64-is_compat_task-fix.patch"

---
 arch/ia64/include/asm/compat.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/ia64/include/asm/compat.h
+++ b/arch/ia64/include/asm/compat.h
@@ -204,4 +204,9 @@ arch_compat_alloc_user_space (long len)
 	return (void __user *) (((regs->r12 & 0xffffffff) & -16) - len);
 }
 
+/* for !COMPAT this is defined in linux/compat.h */
+#ifdef CONFIG_COMPAT
+#define is_compat_task() (0)
+#endif
+
 #endif /* _ASM_IA64_COMPAT_H */

--------------090501020904000104020705--
