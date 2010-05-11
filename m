Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0EKH4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:56:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43203 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab0EKH4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vcphgWMKfqQzlMZr1Y3ObXor+UWAh1XkOHwAOJ1SlsME8u8mksEoyxqHnlnthoEzBf
         qB2nPVqZiY2sxVRiZMm32pXncRI9YGEoXk9IejjK0+CI+ElQOW99jAsS1oxpFFfjAYN4
         WgVU1H0/hZM1kYKL0d1j9z+91vxBiimcNDWrQ=
Message-ID: <4BE90DBD.90807@gmail.com>
Date: Tue, 11 May 2010 00:56:45 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Michael Poole <mdpoole@troilus.org>, linux-bluetooth@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: magicmouse: claimed by neither input, hiddev nor hidraw
References: <j2idd18b0c31005101341o43b652c1zf8729f5f9a60e0d3@mail.gmail.com> <alpine.LRH.2.00.1005102334140.14809@twin.jikos.cz> <s2odd18b0c31005101439v22d03bfdw4e65d7c4b8315b6a@mail.gmail.com> <alpine.LNX.2.00.1005102351220.28092@pobox.suse.cz> <4BE8859E.3090305@gmail.com> <87mxw7i33j.fsf@troilus.org> <4BE8C7CD.7030206@gmail.com> <alpine.LNX.2.00.1005110946520.28092@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1005110946520.28092@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/10 00:47, Jiri Kosina wrote:
> On Mon, 10 May 2010, Justin P. Mattock wrote:
>
>> The only other thing that I remember when adding hidraw was adding
>> BT_HCIUART_LL=m (not sure if it matters or not).
>>
>> here is dmesg:
>> http://fpaste.org/OiDf/
>
> Please include the dmesg directly in the mail next time.
>
> Anyway, I don't see the dmesg you provided containing neither the "claimed
> by neither input, hiddev nor hidraw" nor "hw start failed" messages.
>

I'll post that on the next thread
here is the bisect results:


28918c211d86b6eeb70182c523800c7bc442960c is the first bad commit
commit 28918c211d86b6eeb70182c523800c7bc442960c
Author: Michael Poole <mdpoole@troilus.org>
Date:   Tue Mar 9 06:47:35 2010 -0500

     HID: magicmouse: fix oops after device removal

     Ask the HID core not to register an input device for the mouse.
     Fix an oops after removing the device, due to leaving the new
     input device registered.

     Signed-off-by: Michael Poole <mdpoole@troilus.org>
     Signed-off-by: Jiri Kosina <jkosina@suse.cz>

:040000 040000 f84a3ea09666b18abb20b59c128f6fecc5833dfa 
62cdf6cec329e4b761909d02558097ca78d76394 M      drivers

although I have not yet tested this out
with git revert xxxx on the current head.
(me thinks it's another).

here is the bisect log:


# bad: [f1c448e0a9e99c76f4ece368714fb35a40a8daba] Merge branch 
'for-linus' of git://neil.brown.name/md
git bisect bad f1c448e0a9e99c76f4ece368714fb35a40a8daba
# good: [57d54889cd00db2752994b389ba714138652e60c] Linux 2.6.34-rc1
git bisect good 57d54889cd00db2752994b389ba714138652e60c
# bad: [53feb29767c29c877f9d47dcfe14211b5b0f7ebd] cpuset: alloc 
nodemask_t on the heap rather than the stack
git bisect bad 53feb29767c29c877f9d47dcfe14211b5b0f7ebd
# good: [d89b218b801fd93ea95880f1c7fde348cbcc51c5] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git bisect good d89b218b801fd93ea95880f1c7fde348cbcc51c5
# bad: [9d20593a722c2dab7a5ab74f5d8c9b604aca52f9] Merge branch 'merge' 
of git://git.secretlab.ca/git/linux-2.6
git bisect bad 9d20593a722c2dab7a5ab74f5d8c9b604aca52f9
# good: [441f4058a04b2943685ff94e0f5f1992b0b3649e] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
git bisect good 441f4058a04b2943685ff94e0f5f1992b0b3649e
# bad: [961cde93dee2658000ead32abffb8ddf0727abe0] Merge 
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git bisect bad 961cde93dee2658000ead32abffb8ddf0727abe0
# good: [2993cc71d1bff61999ade7f2b6b3ea2dd1e2c8d9] [SCSI] bfa: AEN and 
byte alignment fixes.
git bisect good 2993cc71d1bff61999ade7f2b6b3ea2dd1e2c8d9
# good: [a12b51c478899fe0b7e874a559b05ba35f1128ee] perf tools: Fix 
sparse CPU numbering related bugs
git bisect good a12b51c478899fe0b7e874a559b05ba35f1128ee
# bad: [f82c37e7bb4c4d9b6a476c642d5c2d2efbd6f240] Merge branch 
'perf-fixes-for-linus' of 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad f82c37e7bb4c4d9b6a476c642d5c2d2efbd6f240
# good: [dcd5c1662db59a6b82942f47fb6ac9dd63f6d3dd] perf: Fix unexported 
generic perf_arch_fetch_caller_regs
git bisect good dcd5c1662db59a6b82942f47fb6ac9dd63f6d3dd
# bad: [2886539d5e649c22a6d2107eb431d3bee81e0e6d] HID: ntrig: fix touch 
events
git bisect bad 2886539d5e649c22a6d2107eb431d3bee81e0e6d
# bad: [eff7f270e9a05688066f40589d7b44e1dcf335dc] HID: add quirk for 
UC-Logik WP4030 tablet
git bisect bad eff7f270e9a05688066f40589d7b44e1dcf335dc
# bad: [28918c211d86b6eeb70182c523800c7bc442960c] HID: magicmouse: fix 
oops after device removal
git bisect bad 28918c211d86b6eeb70182c523800c7bc442960c


I'm thinking it might be  HID: ntrig: fix touch

Justin P. Mattock
