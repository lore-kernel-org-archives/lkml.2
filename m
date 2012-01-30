Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab2A3Rfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:35:33 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:28265 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752124Ab2A3Rfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:35:32 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: M9diee0VM1nNDUI3T0GLrGmXKyPI_Ye1HyaG0k.JnYw_NDl
 QK9t9eajxN7nxCoAVpAGdgamb.gfAaSL0uf0PJJKSc3fBEvd8hyULeZFUzLU
 KRSaBDbEfN_Ll0EvKCQusGMrqZlUxTokz1WUCYvzBPfYIK5RM9af7AK58Xm8
 e1kZ1lkaJZcqP.8juv60bJj6ads5NBg0cPfdcOmLb.RN3c7S5NFXCyXFgOx.
 7seFsNE7yXOPi9BKePiZ60NaPQ_cOW4pN_Ei9KNTVlLRCha39S4XeLaQINrc
 UG4JZpKKmyqsclnT2SNB9IoxjyWtmkrLpXjT1sAIaucvxwS2p1wqv6RGW0JR
 4NriVUePwIz_mLUBmP4gvWhsvlTBU0NlZsp0WN.zIkkovaesUIhFG8MK_dbA
 U
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 11:35:29 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130173311.GE3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301134090.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <20120130171919.GC3355@google.com> <alpine.DEB.2.00.1201301122410.28693@router.home> <20120130173311.GE3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> I'm pretty sure it never gives out NULL for a dynamic allocation.  The
> base might be mapped to zero but we're guaranteed to have some static
> percpu areas there and IIRC the percpu addresses aren't supposed to
> wrap.

True but there is a check for a NULL pointer on free. So a NULL pointer
currently has the semantics of being an unallocated per cpu structure.
If the allocator returns NULL by accident then we cannot free the per cpu
allocation anymore.
