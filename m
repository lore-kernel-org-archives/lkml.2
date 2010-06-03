Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab0FCIxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:53:19 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:47958 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab0FCIxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ne5rLhPClL+S7Itvu/i1MfPczkoE9AKWKkDba+W7URh1NH/YKtPRZOJanetMz6wKJu
         WqZz2JnRBVpM/Z76HRfMQRMDVxPKJE4jDw5CqoR1hYLYq0/Ab7zJZYeAZgturvYSegwE
         y5779RsNJsxlkoYsTQEfhExyI3FhsLnle/VTI=
Date: Thu, 3 Jun 2010 16:57:11 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       ebiederm@aristanetworks.com, randy.dunlap@oracle.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: Suppress compiler warning with gcc 3.x
Message-ID: <20100603085711.GD5580@cr0.nay.redhat.com>
References: <201006030523.o535NA16029042@www262.sakura.ne.jp>
 <1275543101.29413.76.camel@edumazet-laptop>
 <20100603055515.GA5580@cr0.nay.redhat.com>
 <m1y6ewr6vf.fsf@fess.ebiederm.org>
 <20100603062314.GB5580@cr0.nay.redhat.com>
 <m1k4qgr54j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m1k4qgr54j.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 11:40:12PM -0700, Eric W. Biederman wrote:
>Américo Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Wed, Jun 02, 2010 at 11:02:28PM -0700, Eric W. Biederman wrote:
>>>Américo Wang <xiyou.wangcong@gmail.com> writes:
>>>
>>>> On Thu, Jun 03, 2010 at 07:31:41AM +0200, Eric Dumazet wrote:
>>>>>Le jeudi 03 juin 2010 à 14:23 +0900, Tetsuo Handa a écrit :
>>>>>> Gcc 3.x generates a warning
>>>>>> 
>>>>>>   include/linux/sysfs.h:183: warning: parameter has incomplete type
>>>>>> 
>>>>>> on each file.
>>>>>> Suppress the warning by moving the definition of "enum kobj_ns_type"
>>>>>> to before "#include <linux/sysfs.h>".
>>>>>> 
>>>>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>>>>
>>>>>
>>>>>I was about to submit same patch, but I was also reverting 27eabc7cb4b3
>>>>>(sysfs: Don't use enums in inline function declaration.)
>>>>>
>>>>>So that sysfs_exit_ns() prototype is consistent regardless of
>>>>>CONFIG_SYSFS
>>>>>
>>>>>What do you think ?
>>>>>
>>>>
>>>> This looks odd, in sysfs.h we do have a forward declaration of
>>>> enum kobj_ns_type... I am wondering why gcc 3.x doesn't recognize it.
>>>
>>>Because the replacement is an inline, and we are passing the enum by value
>>>gcc wants to see the full definition, at the point where the inline function
>>>is declared.
>>>
>>
>> But sysfs_exit_ns() is not inlined if CONFIG_SYSFS here.
>
>You are right gcc 3.x seems full of it.  I was thinking of the !CONFIG_SYSFS
>case where I had to pull out the enum because it is in fact inlined.
>
>If we are going to worry about gcc 3.x and about my !CONFIG_SYSFS
>inline function the clean way to handle this seems to be to introduce
>a new header file that both sysfs.h and kobject.h can include.

Agreed.

>Assuming/requiring that files that include sysfs.h also include
>kobject.h to seems like the wrong way to go.


Yeah.

However, this compile warning only appears in gcc 3.x
and it seems it's a fault of gcc 3.x, not the code. I am wondering
if we need to fix it.

Thanks.

