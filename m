Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab2CLNgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 09:36:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2CLNgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 09:36:47 -0400
Date: Mon, 12 Mar 2012 09:36:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
Message-ID: <20120312133619.GB17288@redhat.com>
References: <m1ipip6xe8.fsf@fess.ebiederm.org>
 <4F573E1C.2060909@oss.ntt.co.jp>
 <4F573E74.5040504@oss.ntt.co.jp>
 <m1eht31z8e.fsf@fess.ebiederm.org>
 <4F58495B.5080308@oss.ntt.co.jp>
 <m1r4x3yrsv.fsf@fess.ebiederm.org>
 <4F5A6D87.4050809@zytor.com>
 <4F5D8D0E.8060702@oss.ntt.co.jp>
 <4F5D8E63.60606@zytor.com>
 <4F5D943C.5020403@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F5D943C.5020403@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 03:14:20PM +0900, Fernando Luis Vázquez Cao wrote:

[..]
> The thing is that we want to avoid playing with hardware in the kdump
> reboot patch when we can avoid it, the premise being that it cannot
> be accessed without risking a lockup or worse (as the deadlock accessing
> the I/O APIC showed).

I think there needs to be a limit to being paranoid. On one hand people
want to run panic notifiers, all the kmsg_dump() hooks in panic path, and
on the other hand we are afraid of even disabling LAPIC.

I personally think that disabling LAPIC is reasonably practical solution
to the problem until and unless somebody shows that it deadlocks easily.

Thanks
Vivek
