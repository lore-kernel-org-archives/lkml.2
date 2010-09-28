Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468Ab0I1A46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:56:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63392 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760352Ab0I1A45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:56:57 -0400
Date: Tue, 28 Sep 2010 08:55:58 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Update num_symtab, symtab and strtab right after setup
 of core_num_syms, core_symtab and core_strtab.
Message-ID: <20100928005558.GA6044@localhost.localdomain>
References: <20100927073028.GA1040@localhost.localdomain>
 <20100927080954.GC5785@cr0.nay.redhat.com>
 <20100927082247.GA2463@localhost.localdomain>
 <20100927085425.GE5785@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100927085425.GE5785@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 04:54:25PM +0800, Américo Wang wrote:
> On Mon, Sep 27, 2010 at 04:22:47PM +0800, Hu Tao wrote:
> >On Mon, Sep 27, 2010 at 04:09:54PM +0800, Américo Wang wrote:
> >> On Mon, Sep 27, 2010 at 03:30:28PM +0800, Hu Tao wrote:
> >> >Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> >> 
> >> 
> >> Changelog is empty.
> >> What bug did you observe?
> >
> >symtab and strtab will point to vfreed memory after free_copy(&info)
> >near end of load_module().
> >
> 
> I think you must mean the error path in load_module(), yeah, probably.

No. There is a free_copy(&info) at the end of normal path of load_module().

> 
> But you need to check if this patch misses other thing, like
> the other functions which are called after add_kallsyms() inside load_module().
> According to my eyes, this seems fine (at least on x86), so
> 
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks for review.

> 
> >> 
> >> 
> >> This patch is not correct, symbols that are not core symbols will be
> >> dropped right after this piece of code. So NACK.
> >
> >There is the reason why we should update num_symtab, symtab and strtab
> >before non-core-symbols are dropped.
> 
> init section is dropped *after* these value are update, which is correct.
> 
> Again, you need to describe what you are trying to fix in your changelog.
> Please resend it with a proper changelog.
> 
> Thanks.
