Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423124Ab2JaPdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:33:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40600 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423001Ab2JaPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:33:23 -0400
Message-ID: <509144C0.8000601@converseincode.com>
Date: Wed, 31 Oct 2012 11:33:20 -0400
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: balbi@ti.com
CC: davem@davemloft.net, linux-usb@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] Remove VLAIS usage from gadget code
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com> <1351631937-21455-3-git-send-email-behanw@converseincode.com> <20121031132838.GQ10998@arwen.pp.htv.fi>
In-Reply-To: <20121031132838.GQ10998@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-10-31 09:28 AM, Felipe Balbi wrote:
> hi,
>
> On Tue, Oct 30, 2012 at 05:18:56PM -0400, Behan Webster wrote:
>> The use of variable length arrays in structs (VLAIS) in the Linux Kernel code
>> precludes the use of compilers which don't implement VLAIS (for instance the
>> Clang compiler). This patch instead calculates offsets into the kmalloc-ed
>> memory buffer using macros from valign.h.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
> this won't apply after the current cleanups I applied to gadget code
> from Sebastian.
Makes sense. I'll try it with your repo, and regenerate.

> If someone takes this patch, it will generate a series of annoying,
> hard-to-figure-out conflicts (at least judging by the looks of
> $SUBJECT).
I just tried the patch on your git.kernel.org repo and thankfully there 
is only one hunk which is rejected, and fortunately the reason is 
trivial (descriptors -> fs_descriptors).

Was:
-        func->function.descriptors = data->fs_descs;
+        func->function.descriptors = fs_descs;

Now is:
-        func->function.fs_descriptors = data->fs_descs;
+        func->function.fs_descriptors = fs_descs;

I will regenerate the patch set, but obviously the new gadget patch in 
the V3 patchset will only apply to the USB repo, and not to the 
netfilter repo.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

