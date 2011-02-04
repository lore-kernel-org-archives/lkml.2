Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1BDUTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:19:07 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62071 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1BDUTG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U47Iw8lGYpN8UEi2Gn6dsFmo57NPx14WutR4lY7FckVNYuyHZWL+JGlGGLVTlnJPKX
         HYYdccbmKwic0reKIz7s9jO08u/Z4zt20vGQl6W+89ViNlSlMHUMqWQFALtBEMIJ/jna
         9u4ZPj7bl5GZgp9qXoIwbzmqK3hiXhxQU9Nm0=
MIME-Version: 1.0
In-Reply-To: <4D4C5CE1.2090006@zytor.com>
References: <1296783486-23033-1-git-send-email-kamal@canonical.com>
	<AANLkTimDrWESfmSwRSyhenZTwXovKKa4mSC=Y0=j9yPM@mail.gmail.com>
	<4D4C5CE1.2090006@zytor.com>
Date: Fri, 4 Feb 2011 12:19:05 -0800
X-Google-Sender-Auth: MXH4FQxdnOn--m_gBFa0eSnkK54
Message-ID: <AANLkTi=FwrG43Br3RVNDJ1Z4UJNgfYt6ih=Gv=0HEtG-@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: fix panic when handling "mem={invalid}" param
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kamal Mostafa <kamal@canonical.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 12:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/04/2011 11:44 AM, Yinghai Lu wrote:
>> On Thu, Feb 3, 2011 at 5:38 PM, Kamal Mostafa <kamal@canonical.com> wrote:
>>> Avoid removing all of memory and panicing when "mem={invalid}" is
>>> specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on platforms
>>> other than x86_32).
>>>
>>> BugLink: http://bugs.launchpad.net/bugs/553464
>>> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
>>> Cc: <stable@kernel.org>
>>> ---
>>>  arch/x86/kernel/e820.c |    3 +++
>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>>> index 294f26d..55a59d8 100644
>>> --- a/arch/x86/kernel/e820.c
>>> +++ b/arch/x86/kernel/e820.c
>>> @@ -856,6 +856,9 @@ static int __init parse_memopt(char *p)
>>>
>>>        userdef = 1;
>>>        mem_size = memparse(p, &p);
>>> +       /* don't remove all of memory when handling "mem={invalid}" param */
>>> +       if (mem_size == 0)
>>> +               return -EINVAL;
>>>        e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
>>>
>>>        return 0;
>>> --
>>
>> then how about some one pass mem=32M etc?
>>
>> or total wrongly usermap?
>>
>
> All he looks at is when the value returned is zero.  It wouldn't be zero
> for any actual value, including mem=32M.
>

when user pass wrong parameter like less 128M, kernel will not boot either.
Do we need to sanity check for that?

Yinghai
