Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab0I0It4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 04:49:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57627 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab0I0Itz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 04:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZuSOnwT6+zt5lF7Nvif85v0HE7Yo+xxPiz9ZqWebciu7Mh6BhI87iIeqXTVPeD/1ML
         Vd2+I/701bJYjFyotbN5MEHSnMzaKu6p369nEhcbiMoeR5eAgKSwHWOad1BELBrXa1iq
         VJnodINJB6DcHeY/kGsm4twDL6d4PY77pD7VI=
Date: Mon, 27 Sep 2010 16:54:25 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Update num_symtab, symtab and strtab right after setup
 of core_num_syms, core_symtab and core_strtab.
Message-ID: <20100927085425.GE5785@cr0.nay.redhat.com>
References: <20100927073028.GA1040@localhost.localdomain>
 <20100927080954.GC5785@cr0.nay.redhat.com>
 <20100927082247.GA2463@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100927082247.GA2463@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 04:22:47PM +0800, Hu Tao wrote:
>On Mon, Sep 27, 2010 at 04:09:54PM +0800, Américo Wang wrote:
>> On Mon, Sep 27, 2010 at 03:30:28PM +0800, Hu Tao wrote:
>> >Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
>> 
>> 
>> Changelog is empty.
>> What bug did you observe?
>
>symtab and strtab will point to vfreed memory after free_copy(&info)
>near end of load_module().
>

I think you must mean the error path in load_module(), yeah, probably.

But you need to check if this patch misses other thing, like
the other functions which are called after add_kallsyms() inside load_module().
According to my eyes, this seems fine (at least on x86), so

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>> 
>> 
>> This patch is not correct, symbols that are not core symbols will be
>> dropped right after this piece of code. So NACK.
>
>There is the reason why we should update num_symtab, symtab and strtab
>before non-core-symbols are dropped.

init section is dropped *after* these value are update, which is correct.

Again, you need to describe what you are trying to fix in your changelog.
Please resend it with a proper changelog.

Thanks.
