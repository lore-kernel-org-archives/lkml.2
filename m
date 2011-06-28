Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1F1XVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 19:21:13 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:47619 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1F1XVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 19:21:07 -0400
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Jun 2011 19:21:06 EDT
Message-ID: <4E0A5F2B.9010302@knaff.lu>
Date: Wed, 29 Jun 2011 01:09:31 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Pavel Machek <pavel@ucw.cz>, dosfstools <daniel@debian.org>,
        mtools <Alain.Knaff@linux.lu>, linux-kernel@vger.kernel.org
Subject: Re: End of FAT directories
References: <1303498136.8485.128.camel@localhost>	<87hb9qnho4.fsf@devron.myhome.or.jp>	<1303509408.8485.146.camel@localhost>	<87bozxomqd.fsf@devron.myhome.or.jp>	<1303558711.8485.166.camel@localhost> <20110428132551.GA5701@ucw.cz>	<1303998185.8188.18.camel@localhost> <87d3k6idnz.fsf@devron.myhome.or.jp>
In-Reply-To: <87d3k6idnz.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've just released mtools 4.0.17

It fixes the issue by:
1. Considering all directory entry after an "endmark" (first byte of
filename zero) to be free, even if the first byte is not zero (this
avoids the problem of not finding any free space because of phantom
entries after endmark)
2. Writing an endmark after having created a filename that's beyond the
endmark (this avoids the problem of accidentally transforming phantom
entries into real entries by "filling the gap")

http://www.gnu.org/software/mtools/download.html

Thanks for drawing my attention to this issue.

Regards,

Alain


On 2011-04-28 17:44, OGAWA Hirofumi wrote:
> Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de> writes:
> 
>> Am Donnerstag, den 28.04.2011, 15:25 +0200 schrieb Pavel Machek:
>>>>>  For overwriting the
>>>>> zeroed entry, why we have to check all entries until see next zeroed
>>>>> (yeah, now, we allowed the crappy data after zeroed)?
>>>> My point was not about checking all entries until the next zeroed entry,
>>>> which is overcomplicating stuff. I meant that if we hit the end (i.e.
>>>> the first zeroed entry) when searching for free slots, in that case we
>>>> just clear the one entry directly following the inserted entries. This
>>>> makes sure that no files magically appear. I *do* understand that
>>> This sounds like a good idea, and costs nothing. I hope we can
>>> convince Ogawa...
>>
>> I am going to implement that and publish a patch. If the patch is clean
>> enough, maybe we can convince him. But the freedom of open source can't
>> prevent me from using a patch like that, of course. And maybe it also
>> helps when the patch gets some testing.
> 
> Of course, it's good to publish. However if you can't detect buggy or
> corrupted directory, I wouldn't ack to help buggy stuff.
> 
> So it can be the mount option, but I can't see at all the point it is
> in-kernel as FS.
> 
>>> Kernel should stop at zero invalid entry.
> 
> I'm not complaining to stop at zero. Rather I acked already if it didn't
> overwrite after zeroed entry.
> 
>>> fsck should consider any garbage past zero entry as an error, and zero
>>> it out. (Complaining about duplicate blocks is unhelpful but better
>>> than nothing.  It should really zero the garbage out.)
>>
>> In fact, what you describe is something I would call "consistent". I was
>> not implying that kernel and dosfsck should do exactly the same thing,
>> but I was implying that the kernel and dosfsck should either both or
>> none consider entries past the gap as existing file.
>> Current state is: both consider past-gap entries valid. Your described
>> state will be: none consider past-gap entries valid. The behaviour you
>> describe is exactly what I would imagine as best way to go. Maybe fsck
>> should ask for "shift post-gap entries/create a dummy deleted entry"
>> vs. "clear post-gap entries".
> 
> Yes. Also my opinion is the fsck should get ack from user to overwrite
> data or salvage (has possibility to salvage) if interactive mode, then
> fixes it.
> 
> Thanks.
