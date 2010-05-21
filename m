Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab0EUPPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 11:15:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64784 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab0EUPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 11:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EALrvPBNbglcJUfk5oTbFENvVZwnfDPw54JHSCrOuPTqxenZG5Xe1XsL8RcVKZ8juB
         U4RwAQVoUsnXv2JHVHsYp7QkCw6umcpfwQ1bGdqYEkGsAXdc5NoDl3lcE0yhKwUYBfrs
         bO18kVdgPwlaET7qhwn4FLj5OqI41veFg7fFo=
MIME-Version: 1.0
In-Reply-To: <20100520131230.41a99489@lxorguk.ukuu.org.uk>
References: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>
	 <4BF42296.1030905@oracle.com> <4BF4235D.3080904@zytor.com>
	 <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>
	 <4BF46D9B.4090806@zytor.com>
	 <AANLkTiltANJ9eaGBkfJJOyZ8skCxxOmkAs1UvCLB_YQ9@mail.gmail.com>
	 <20100520131230.41a99489@lxorguk.ukuu.org.uk>
Date: Fri, 21 May 2010 08:15:08 -0700
Message-ID: <AANLkTinEXX6ZQoauZH3Du-z69Lx_xoUfzTb8vxhoc09i@mail.gmail.com>
Subject: Re: [PATCH] Prevent reserving RAM in the region already reserved by 
	BIOS
From: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai <yinghai.lu@oracle.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 5:12 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 19 May 2010 17:01:41 -0700
> Mathieu Rondonneau <mathieu.rondonneau@gmail.com> wrote:
>
>> it' s not in ISA space.
>> once loading the NVIDIA driver, the warnign oops shows up.
>> 4K starting at 0x9f800 (i.e. to 0xa007ff) overlap with the ISA space
>> (starting at 0xa0000).
>
> If this is the proprietary Nvidia driver you need to take the matter up
> with Nvidia. I assume they are trying to remap chunks of the EBA for some
> reason.
>
> And please can you not top post to this list, it makes it very hard to
> follow when you are replying in a different order to everyone else.
>
> Alan
>

Thanks Alan, I will post on NVIDIA forum. Thanks for the feedback.

Yinghai, your patch had some missing parameter for the sanitize function.
It does fixes the bios side (/proc/iomem) that now shows only aligned sections.
But it does not prevent the Nvidia driver to try to allocate on non-4K
align (i.e. if this is what' s happening).

Thanks for the help,
-Mathieu
