Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab1I2OIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:08:52 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:41662 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754590Ab1I2OIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:08:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 49so3.EVM1nmUimaeOhFLJfUz_sCeVi74bjSMyvImKIfYM1
 VBkmpJh8F34vJ1Qkfe4xRAxKj_VuZnci9NAVM.Bnm9fx.z11eykByLdcbMMu
 vgKNtiwW.KWp25KlcE0Ki2atfkKMSj8yHigM8v9qXKSFkJbdylJ.BgXi7PgG
 L4uYIRlgK7cCIvjcQM1Sa4OepcAsNS5sMgVmCZ.eFgI3pJSHX.geeNytfMt5
 RjIYhzBM0S8lXdSuYE9Q7uf8jTdLg8BNHQRUImFEpQ9AoIrTJBqF_.3lwMyC
 5ebx2s4Jft8D9qtl0QHyOAawa3cKvGVqY7DzgJz114IDB20r9tbUkdMApMde
 2guXLKAgOiYpils3yVs4KTEPQK3MWk61f5Q3UyivTVrVY3KQQNUAzhIIWFBS
 9hqafVLLjZgFWRLct4pApXsw93fejRuctxkfLtcu7OiNWb_GK
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 29 Sep 2011 09:08:47 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: Catalin Marinas <catalin.marinas@arm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Huajun Li <huajun.li.lee@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: Question about memory leak detector giving false positive report
 for net/core/flow.c
In-Reply-To: <20110928172342.GH23559@e102109-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.00.1109290907450.9382@router.home>
References: <CA+v9cxadZzWr35Q9RFzVgk_NZsbZ8PkVLJNxjBAMpargW9Lm4Q@mail.gmail.com> <1317054774.6363.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110926165024.GA21617@e102109-lin.cambridge.arm.com> <1317066395.2796.11.camel@edumazet-laptop>
 <20110928172342.GH23559@e102109-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Sep 2011, Catalin Marinas wrote:

> I tried this but it's tricky. The problem is that the percpu pointer
> returned by alloc_percpu() does not directly point to the per-cpu chunks
> and kmemleak would report most percpu allocations as leaks. So far the
> workaround is to simply mark the alloc_percpu() objects as never leaking
> and at least we avoid false positives in other areas. See the patch
> below (note that you have to increase the CONFIG_KMEMLEAK_EARLY_LOG_SIZE
> as there are many alloc_percpu() calls before kmemleak is fully
> initialised):

Seems that kernel.org is out and so tejon wont be seeing these.

