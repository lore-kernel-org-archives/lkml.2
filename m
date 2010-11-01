Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0KARmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:42:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0KARml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:42:41 -0400
Date: Mon, 1 Nov 2010 15:19:37 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, kernel-janitors@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: kvm: x86: fix information leak to userland
Message-ID: <20101101171937.GA4484@amt.cnet>
References: <1288447871-7715-1-git-send-email-segooon@gmail.com>
 <4CCC2D11.7090109@web.de>
 <20101030153147.GA14169@albatros>
 <4CCC3DC2.6090505@web.de>
 <20101030185447.GA7629@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101030185447.GA7629@albatros>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 10:54:47PM +0400, Vasiliy Kulikov wrote:
> Structures kvm_vcpu_events, kvm_debugregs, kvm_pit_state2 and
> kvm_clock_data are copied to userland with some padding and reserved
> fields unitialized.  It leads to leaking of contents of kernel stack
> memory.  We have to initialize them to zero.
> 
> In patch v1 Jan Kiszka suggested to fill reserved fields with zeros
> instead of memset'ting the whole struct.  It makes sense as these
> fields are explicitly marked as padding.  No more fields need zeroing.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tesed only.
> 
>  arch/x86/kvm/x86.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Applied, thanks.

