Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab2FKBgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 21:36:52 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:37007 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2FKBgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 21:36:50 -0400
Message-ID: <4FD54B9B.7020309@linux.vnet.ibm.com>
Date: Mon, 11 Jun 2012 09:36:27 +0800
From: Zhong Li <zhong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Jan Beulich <JBeulich@suse.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com> <4FCDDB7D0200007800088390@nat28.tlf.novell.com> <20120605144734.GU32472@redhat.com> <4FCE44FC0200007800088524@nat28.tlf.novell.com> <20120605183539.GA32472@redhat.com> <4FCF57B902000078000887EA@nat28.tlf.novell.com> <20120606140357.GB32472@redhat.com> <1339055005.18639.11.camel@ThinkPad-T420> <20120607124800.GH32472@redhat.com> <20120608205138.GA29664@redhat.com>
In-Reply-To: <20120608205138.GA29664@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12061015-1396-0000-0000-0000015F0018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2012 04:51 AM, Don Zickus wrote:
> On Thu, Jun 07, 2012 at 08:48:00AM -0400, Don Zickus wrote:
>> On Thu, Jun 07, 2012 at 03:43:25PM +0800, Li Zhong wrote:
>>> On Wed, 2012-06-06 at 10:03 -0400, Don Zickus wrote:
>>>> On Wed, Jun 06, 2012 at 12:14:33PM +0100, Jan Beulich wrote:
>>>>>> I didn't think it would be compiler dependent as I do not know what
>>>>>> compiler the reporter was using.  I used a RHEL-6 4.4.4 compiler (which
>>>>>> you probably don't have :^) ).
>>>>> Indeed, somehow I failed to see the obvious - it's commit
>>>>> 72b3fb24713755cf9740b403e95aa67ceedf3509 that causes
>>>>> these problems. Instantiating static data like this just doesn't
>>>>> play with any of the pointers passed being into .init.*.
>>>>>
>>>>> I'd suggest either open coding register_nmi_handler() (with
>>>>> the static data put into __initdata), or further abstracting it
>>>>> by allowing an optional fifth argument (specifying the section
>>>>> annotation if needed).
>>>> Ah.  Thanks for figuring that out!!  I will post a patch opencoding it.
>>>>
>>> Hi Don,
>>>
>>> How about the following patch, adding an optional fifth argument as Jan
>>> mentioned? We don't need change other users of register_nmi_handler().
>> Ah, ok.  I forgot about the variable args syntax.  That works too.  I give
>> a quick test.
> Apparently I was too slow.  Ingo committed my other patch.  I can ask him
> to revert it and use your smaller/cleaner patch instead?  Or is it big
> deal to keep the other one?
This other way is fine to me, they actually does the same thing.

Sorry for causing the trouble, though I don't remember seeing the 
warnings when converting it to static ...

Thanks,
Zhong
> Cheers,
> Don
>

