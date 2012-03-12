Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2CLUDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:03:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52461 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab2CLUDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:03:41 -0400
Message-ID: <4F5E566D.9060209@zytor.com>
Date: Mon, 12 Mar 2012 13:02:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXU=?= =?UTF-8?B?ZXogQ2Fv?= 
	<fernando@oss.ntt.co.jp>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
References: <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com> <4F5D943C.5020403@oss.ntt.co.jp> <20120312133619.GB17288@redhat.com> <m1ipi9prrl.fsf@fess.ebiederm.org>
In-Reply-To: <m1ipi9prrl.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 12:02 PM, Eric W. Biederman wrote:
> 
> Disabling NMI generation in the LAPIC is fine, and for the short term
> I don't even have a problem with disabling the entire LAPIC as all of
> our platforms seem to have code for completely reprogramming it.
> 
> At the same time there have been cases like the i8259 routed through
> the ExtInt pin of the lapci that we haven't been given programming
> information about and that if we want to work we should avoid touching.
> 

I'm pretty sure that information is in the SDM (I'm looking at it now.)

You can also block NMI though this route, since external NMI really is
LINT1 and hence is routed through the LAPIC; you can mask it by clearing
bit 16 in LVT LINT1 as described in the SDM.

	-hpa

