Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab1FIMNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:13:20 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:35406 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284Ab1FIMNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FtFXByLSTwl7/Ecd5wDm/cj5TcLLogwtoz/e3WIspdZ7KMHHxXjMjPLFurhk1JHNgD
         kgqwhiDee+q81YXYWF1fqOHjI9RjkVYLYHCeC2+rDRDIpv+5rcvl7VUd0EkeP9TVoax/
         3QubmC3tSuxwV1qyKX0GvZZInK6WcDcIKeDf8=
MIME-Version: 1.0
In-Reply-To: <1307596281.3980.59.camel@edumazet-laptop>
References: <20110609004435.14550.qmail@science.horizon.com>
 <4DF037C6.4000507@linux.intel.com> <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
 <1307591659.3980.37.camel@edumazet-laptop> <BANLkTi=E9gR3JHa4ipHHGGR2AiO9xJri=A@mail.gmail.com>
 <1307596281.3980.59.camel@edumazet-laptop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 9 Jun 2011 08:12:56 -0400
X-Google-Sender-Auth: XEUEYgM21N9bE-V15vMd8nRmaIQ
Message-ID: <BANLkTinzOFOjfhcaVD6Oym+-Uan3-R_Maw@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>, George Spelvin <linux@horizon.com>,
        david@rgmadvisors.com, kyle@moffetthome.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 1:11 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 09 juin 2011 à 00:10 -0400, Andrew Lutomirski a écrit :
>> On Wed, Jun 8, 2011 at 11:54 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >
>> > You can not prevent DOS on a machine if you allow a process to RO map
>> > your critical files (where you put futexes), because you allow this
>> > process to interfere with critical cache lines bouncing between cpus.
>>
>> The cacheline bounce DoS slows things down and they go back to normal
>> when you kill the DoS-ing task.
>>
>> The wakeup-eating DoS is permanent.  Seems a good deal worse to me.
>>
>> If you make this change, please at least document it in the man page.
>>
>
>
> This is how futexes had working for years.
>
> It was very obvious from the beginning. Please submit a man page change
> since you raised the point. You own the credit to open a CVE and
> immediately release a fix to all 2.6 versions !
>
> How come a critical fix (according to you) went without being noticed
> and documented ?
>

<cynical answer>Because Linux system calls aren't really documented.

It's reasonable to ask people to read a specification of how a system
call works to see if it's well-thought-out, usable, and has good
security properties.

It's also reasonable to ask people to read an implementation of a
system call and check to see that it conforms to the spec.

It's IMO a little less reasonable to ask people to review complicated
mm code to see if the interface it implements is well-designed.

The futex(2) and futex(7) manpages are very incomplete, even
today.</cynical answer>

>
> If its useful, then it needs a futex extension (and this must be
> emulated on old kernels without this extension)

I'm arguing for the extension.  I don't think the kernel has any
obligation to make sure that new use-cases are possible on old
versions, though.

--Andy
