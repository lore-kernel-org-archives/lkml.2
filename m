Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0DFULX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 16:11:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59917 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0DFULR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 16:11:17 -0400
Message-ID: <4BBB9560.6070905@zytor.com>
Date: Tue, 06 Apr 2010 13:11:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: =?UTF-8?B?5p2o56GV?= <shanqn@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: in x86 architecture ,why the function atomic_sub_and_test() does
 not  disable the interrupt?
References: <u2mffe582101004052213zb2e4ec2dp110b8177c04f300e@mail.gmail.com> <adahbnp6rmr.fsf@roland-alpha.cisco.com>
In-Reply-To: <adahbnp6rmr.fsf@roland-alpha.cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2010 11:07 PM, Roland Dreier wrote:
>  > static inline int atomic_sub_and_test(int i, atomic_t *v)
>  > {
>  > 	unsigned char c;
>  > 
>  > 	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
>  > 		     : "+m" (v->counter), "=qm" (c)
>  > 		     : "ir" (i) : "memory");
>  > 	return c;
>  > }
> 
> Why would disabling interrupts be necessary?  The LOCK_PREFIX makes the
> subl atomic, and the sete just operates using the flag set by subl, so
> it doesn't matter if any interrupts occur or not (since returning from
> an interrupt must obviously restore flags).

Even without the LOCK prefix, subl would be atomic against local
interrupts.  The LOCK prefix is only necessary to make it atomic against
other processors.

	-hpa
