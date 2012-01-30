Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2A3R65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 12:58:57 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:42960 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751882Ab2A3R64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 12:58:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sKLC5iQVM1n3yRNyfo7pzpeYWKn_jSsKEq.5Y3uC3xjEG7j
 ETWBian7jWuX79GtNBOvwdcyfBQNYpc7CHH65BIC1AHtb1SktzmY0rn0yFTy
 fBn564oyCT0dlEb6dG9H3Qg4u7IWLGxlmjIbnCIZZzjWQDGN3lP_oyfZeLqE
 5hEOO2tA3d0YBGNtgZ1FgtB1bose_CzZdFBEsdB5xkraNS5QdB15Y9h9w0Cn
 I_7cSAJXN5cvFha2CcUeWJRmhkX18jW0cozmiQUCC4PsV3y29zrRPV9OlTWl
 RXEDcIQ.XjOqdleoknosJ.iKS_kSyq31bn3lGp5YjoPc9bkyal8.NdTVu10L
 F13EsXPGBHPjt.Aregyhdx2Y2sbIqdhFnXx9uf2xthOk9.la41._M..0XsOJ
 S
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 11:58:52 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH 1/3] percpu: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
In-Reply-To: <20120130175434.GG3355@google.com>
Message-ID: <alpine.DEB.2.00.1201301156530.28693@router.home>
References: <1327912654-8738-1-git-send-email-dmitry.antipov@linaro.org> <20120130171558.GB3355@google.com> <alpine.DEB.2.00.1201301121330.28693@router.home> <20120130174256.GF3355@google.com> <alpine.DEB.2.00.1201301145570.28693@router.home>
 <20120130175434.GG3355@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Tejun Heo wrote:

> Hello, Christoph.
>
> On Mon, Jan 30, 2012 at 11:52:23AM -0600, Christoph Lameter wrote:
> > We have two possibilities now:
> >
> > 1. We say that the value returned from the per cpu allocator is an opaque
> > value.
> >
> > 	This means that we have to remove the NULL check from the free
> > 	function. And audit the kernel code for all occurrences where
> > 	a per cpu pointer value of NULL is assumed to mean that no per
> > 	cpu allocation has occurred.
>
> No, NULL is never gonna be a valid return from any allocator including
> percpu.  Percpu allocator doesn't and will never do so.

How do you prevent the percpu allocator from returning NULL? I thought the
per cpu offsets can wrap around?

> > 2. We say that there are special values for the per cpu pointers (NULL,
> > 	ZERO_SIZE_PTR)
> >
> > 	Then we would have to guarantee that the per cpu allocator never
> > 	returns those values.
> >
> > 	Plus then the ZERO_SIZE_PTR patch will be fine.
> >
> > 	The danger exist of these values being passed as
> > 	parameters to functions that do not support them (per_cpu_ptr
> > 	etc). Those would need VM_BUG_ONs or some other checks to detect
> > 	potential problems.
>
> I'm saying we don't have this for ZERO_SIZE_PTR in any meaningful way
> at this point.  If somebody wants to implement it properly, please
> feel free to, but simply applying ZERO_SIZE_PTR without other changes
> doesn't make any sense.

We have no clean notion of how a percpu pointer needs to be handled. Both
ways of handling things have drawbacks.


