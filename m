Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab0K3JUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:20:11 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40625 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0K3JUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:20:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vb/yFD/kvo0WzYoGjr5i9nv1wVDm5EJxhtHM1SqpycGjR8oxLkp/V4EBCPG74KTxUg
         NEKh3x0XWPNCECuCksaghqHbVuqAI+mQNlX165q8K3DjIOiLdwTipxrh3H61oR3gfxMm
         CuZHb1/Umh6xAVCb62HLGbcTdrz+xN0O8Ref0=
Date: Tue, 30 Nov 2010 17:24:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
Message-ID: <20101130092458.GC5203@cr0.nay.redhat.com>
References: <4CF30B46.4000203@pavlinux.ru>
 <1291042737.30543.730.camel@gandalf.stny.rr.com>
 <4CF401DD.4000908@pavlinux.ru>
 <1291069113.30543.876.camel@gandalf.stny.rr.com>
 <1291069616.30543.879.camel@gandalf.stny.rr.com>
 <4CF42E07.40207@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF42E07.40207@pavlinux.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 01:49:43AM +0300, Pavel Vasilyev wrote:
>On 30.11.2010 01:26, Steven Rostedt wrote:
>> On Mon, 2010-11-29 at 17:18 -0500, Steven Rostedt wrote:
>>
>>> Um, do you realize that the kernel does not always use the same memcmp
>>> as gcc.
>>>
>> Note, I'm not against the change, because in 99% of the cases, memcmp()
>> can and will be faster, and we don't need to worry about these strange
>> cases.
>>
>> What I'm against is a blind s/strncmp/memcmp/ of the kernel, because it
>> may have side effects that you may not have thought of.
>>
>Then we have to hang a large banner that is visible to all developers.
>"Change wherever possible strncmp to memcmp," :)
>

Why? Strings are strings, they are ended by '\0', well-deserved to use str*()
functions rather than mem*().
