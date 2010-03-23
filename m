Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab0CWCdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 22:33:51 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:35263 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0CWCdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 22:33:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F15n+u2SQbwZXuXYWgXuRyuOVvdiErbO/dtzQ6XkoR+E8djrIsunKBD15dwQwCFnWt
         CjaxtjgLlMc3odwcefE9V466fYz90WSe59WqAQgFuL8cqFYdjyHj1vJ/eOXCtUtKdRL/
         6J7kGzlt3gA4Hwb64ytLu40xDJfBUafibBhyE=
MIME-Version: 1.0
In-Reply-To: <28495.1269258639@redhat.com>
References: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
	 <28495.1269258639@redhat.com>
Date: Tue, 23 Mar 2010 10:33:49 +0800
Message-ID: <7d86d44a1003221933x50378b37oe9556e1f169ff15a@mail.gmail.com>
Subject: Re: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
From: graff yang <graff.yang@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: tj@kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 7:50 PM, David Howells <dhowells@redhat.com> wrote:
> <graff.yang@gmail.com> wrote:
>
>> -     return virt_to_page(addr);
>> +     return (struct page *)
>> +                     (virt_to_page(addr)->index) ? : virt_to_page(addr);
>
> Can the extra conditional operator be made subject to CONFIG_SMP?

OK.
Tejun is looking into the up layer percpu code. So I expecting there
is better way
to hook nommu in.


>
>> -     return page_to_pfn(virt_to_page(addr));
>> +     return page_to_pfn((struct page *)
>> +                     (virt_to_page(addr)->index) ? : virt_to_page(addr));
>
> Ditto.
>
>> +#ifdef CONFIG_SMP
>> ...
>> +#endif
>
> Can this be put into a separate file?  There's rather a lot in mm/nommu.c
> these days.
>
> David
>



-- 
-Graff
