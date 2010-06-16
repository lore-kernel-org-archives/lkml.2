Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab0FPKvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:51:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44445 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab0FPKvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=njrAAfwlpoB/DioPanlCYyCWZhFlomCI3xvqVdI8YvWtOAfeRB+V6nW4GUjsGtA2JM
         ppwux5nMTG4fjQ0bJCV8jMu85leVRJWiE1/Wd/KqSi0QrIY0Lc+d7Q7z8nCHq8VO01Oi
         OgrEO1lZC61o8y1GAUHK0k8SB63zAhO/HuoTw=
MIME-Version: 1.0
In-Reply-To: <4C17625E.3020308@redhat.com>
References: <4C16E6ED.7020009@cn.fujitsu.com>
	<4C16E75F.6020003@cn.fujitsu.com>
	<4C16E7AD.1060101@cn.fujitsu.com>
	<4C16E999.6050004@cn.fujitsu.com>
	<4C17625E.3020308@redhat.com>
Date: Wed, 16 Jun 2010 18:51:41 +0800
Message-ID: <AANLkTikZfElLWJvRX2S97FBN2ZVptxg9kYZ7utjHstC6@mail.gmail.com>
Subject: Re: [PATCH 3/6] KVM: MMU: introduce gfn_to_page_atomic() and 
	gfn_to_pfn_atomic()
From: huang ying <huang.ying.caritas@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 7:22 PM, Avi Kivity <avi@redhat.com> wrote:
> btw, is_hwpoison_address() is racy.  While it looks up the address, some
> other task can unmap the page tables under us.
>
> Andi/Huang?
>
> One way of fixing it is get_user_pages_ptes_fast(), which also returns the
> pte, also atomically.  I want it for other reasons as well (respond to a
> read fault by gupping the page for read, but allowing write access if the
> pte indicates it is writeable).

Yes. is_hwpoison_address() is racy. But I think it is not absolutely
necessary to call is_hwpoison_address() in hva_to_pfn_atomic(), is it?

For is_hwpoison_address() in hva_to_pfn(), we can protect it with mmap_sem.

Best Regards,
Huang Ying
