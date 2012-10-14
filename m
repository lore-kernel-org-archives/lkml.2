Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2JNKGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:06:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51764 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2JNKGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:06:06 -0400
Message-ID: <507A8CFE.8000501@gmail.com>
Date: Sun, 14 Oct 2012 11:59:26 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
References: <20121013002003.GL2616@ZenIV.linux.org.uk> <5079164D.4030307@gmail.com> <20121013075128.GQ2616@ZenIV.linux.org.uk> <20121013154810.GA9678@infradead.org> <20121013160115.GS2616@ZenIV.linux.org.uk> <20121013160455.GA32420@infradead.org> <20121013170701.GT2616@ZenIV.linux.org.uk>
In-Reply-To: <20121013170701.GT2616@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 13/10/2012 19:07, Al Viro ha scritto:
> On Sat, Oct 13, 2012 at 12:04:55PM -0400, Christoph Hellwig wrote:
>> On Sat, Oct 13, 2012 at 05:01:15PM +0100, Al Viro wrote:
>>> You know, I'm in the middle of dealing with one such TODO.  Yours, as it
>>> were.  From six years ago.  kernel_thread() unexporting.  TODO comments
>>> of any form are routinely shat upon and ignored, especially when shuffled
>>> away into less read parts of the tree... ;-/
>>>
>>> I'd rather see it done fs-by-fs.  Starting with something reasonably easy
>>> to test - minixfs would do nicely.  Don't get me wrong - I'm all for
>>> burying ->truncate(); what I'm worried about is that we'll end up burying
>>> the warning about the reasons why vmtruncate() was a bad idea, leaving the
>>> functionality exactly as it used to be...
>>
>> As mentioned I agree with the concern in principle.  Let's start by
>> taking Marco's patches for filesystems that use vmtruncate but don't
>> actually implement ->truncate.  There's a few I remember offhand, e.g.
>> procfs and ufs right now.  Then we can do the actual work required ones
>> piece by piece.
>
> Umm... That would be what, procfs?  Frankly, I'm not sure that ATTR_SIZE for
> procfs actually should not be silently ignored.  ->i_size there is completely
> synthetic - it's not as if truncation would actually change the contents.
>
> And ufs situation is quite different - there vmtruncate() is used only on the
> ->write_begin() side.  ->setattr() is already vmtruncate-free.  What's needed
> there is an analog of e.g. ext2_write_failed().
>

I'm open to change the series and give any help. My original idea was to 
do a cleanup patch and after that give to each fs maintainer the 
possibility to do ad-hoc fix. Each fs  maintainer has got a deep 
knowledge of its fs so it was a safe approach from testing point of view 
and so on. However if you tell me that in this case another approach is 
better is ok for me. I'll fix the patches according to the comments of 
Christoph.

Regards,

Marco
