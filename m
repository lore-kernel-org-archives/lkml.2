Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0HaInb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:43:31 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:65517 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0HaIna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:43:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xqlMpemI0tNaHcbTHXQXGyFnkv4oQo5iK/Y2qWMTXP8iQTrzsbHpwMgW5QEMcWlo7S
         GfeL8AV51yHDW0Ji2sIBD795MGZdJYgFOLd8/hds6QjNSzVRnytvlXrTtwajzLafZTjs
         jPdPrOxeCD33v1RCdCqy6uJLIZFrJYQD+HxlY=
MIME-Version: 1.0
In-Reply-To: <4C7CBBBC.3070503@gmail.com>
References: <AANLkTimWnYqFSC=3kqzBVtZHwodCX=MnsViDGmJbUn_8@mail.gmail.com>
	<4C7CBBBC.3070503@gmail.com>
Date: Tue, 31 Aug 2010 14:13:29 +0530
Message-ID: <AANLkTiniKYm7krr1j48VbV7oNDA7YKXzTnuCZ9kOMnUs@mail.gmail.com>
Subject: Re: increasing memory alloted for 'init' during kernel boot.
From: Prabhu Chawandi <prabhu.chavandi@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        listar@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

Thanks for the info...

Problem I am facing is, I have two bootloaders, when I boot from one
loader booting happens properly.

but when I try to load from other loader, kernel does not boot, it
crashes. When i saw the boot logs, I saw that I memory allocated to
'init' section in case of crash is short by almost 5MB to the normal
boot log.

I am using mips processor.

Any idea, why this might be happening ?

thanks,
Prabhu

On Tue, Aug 31, 2010 at 1:52 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 08/31/2010 08:49 AM, Prabhu Chawandi wrote:
>> Hi all,
>>
>>    Whenever the kernel starts booting, I am getting the bellow log :
>>
>> Memory: 110080k/262144k available (2566k kernel code, 151952k
>> reserved, 561k data, 15328k init, 0k highmem).
>>
>> For 'init' on what bases this amount of memory is decided ?
>>
>> Anyways I can alter it?
>
> Nope. It's code and data inside .init, .exit and similar sections. Those
> are marked by __init, __exit etc. in the code. This memory is freed
> after the kernel is up and running, since this memory (code and data) is
> not needed anymore.
>
> regards,
> --
> js
>
