Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2EGJIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 05:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab2EGJIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 05:08:31 -0400
Message-ID: <4FA7910A.9040508@redhat.com>
Date: Mon, 07 May 2012 12:08:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Add mmx movq emulation
References: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com> <4FA64D85.1000609@redhat.com> <20120507085607.GF4687@amd.com>
In-Reply-To: <20120507085607.GF4687@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 11:56 AM, Joerg Roedel wrote:
> > Since you've just thought of the issues involved, I'd appreciate a
> > review of the commits above, both wrt correctness and
> > maintainability.
>
> The patches above look correct to me. In fact cbe2c9d30 is more general
> than my implementation because it fetches all possible mmx operands.
>
> My implementation on the other side should be a bit faster because it
> looks for FP exceptions directly when the registers are accessed which
> saves one get_fpu/put_fpu cycle (and an fwait instruction).

The get_fpu/put_fpu are nops (unless we schedule in between), since we
only put_fpu() doesn't really unload the fpu.  You're correct about the
fwait; my motivation was to get the #MF exception early instead of doing
the accesses first.

> > In fact I already see one difference - my patches do reg &= 7, while
> > your patches generate #UD for %mm8-%mm15.
>
> Your version is correct. Documentation says that REX-prefixes are
> ignored where not supported or misplaced. I also tried that directly on
> hardware and it works as documented and implemented in KVM.

Thanks for verifying.

-- 
error compiling committee.c: too many arguments to function

