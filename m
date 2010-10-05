Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0JEAJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:09:35 -0400
Received: from ozlabs.org ([203.10.76.45]:50268 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab0JEAJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:09:34 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [PATCH resend] Update num_symtab, symtab and strtab right after setup of core_num_syms, core_symtab and core_strtab.
Date: Tue, 5 Oct 2010 10:39:27 +1030
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?q?Am=EF=BF=BD=EF=BF=BDrico_Wang?= 
	<xiyou.wangcong@gmail.com>
References: <20100928010628.GA6923@localhost.localdomain>
In-Reply-To: <20100928010628.GA6923@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010051039.28412.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 10:36:28 am Hu Tao wrote:
> symtab/strtab refer to memory that will be vfreed when load_module() is
> done. So update them early.

I don't think so.  See layout_symtab which moves these into the init
section of the module.

Your change would make us unable to see init section symbols; if you
crash during module init, you really want to see these symbols.

Hope that helps,
Rusty.
