Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2CLUFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:05:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52486 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab2CLUFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:05:30 -0400
Message-ID: <4F5E56EB.1090807@zytor.com>
Date: Mon, 12 Mar 2012 13:04:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>,
        Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        mingo@elte.hu, Yinghai Lu <yinghai@kernel.org>,
        akpm@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com> <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com> <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <4F573E74.5040504@oss.ntt.co.jp> <m1eht31z8e.fsf@fess.ebiederm.org> <4F58495B.5080308@oss.ntt.co.jp> <m1r4x3yrsv.fsf@fess.ebiederm.org> <4F5A6D87.4050809@zytor.com> <4F5D8D0E.8060702@oss.ntt.co.jp> <4F5D8E63.60606@zytor.com> <4F5D943C.5020403@oss.ntt.co.jp> <4F5E431D.8010305@zytor.com> <m1zkblmvw7.fsf@fess.ebiederm.org>
In-Reply-To: <m1zkblmvw7.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2012 01:01 PM, Eric W. Biederman wrote:
> 
> The basic problem is which source do we block this at?  How many
> sources are their?  And architecturally last I looked x86 no longer
> has a NMI disable EFI and similar systems want to get away without
> a CMOS legacy clock because designers so often get them wrong.
> 

On all processors which have an LAPIC you can block all NMI sources at
the LAPIC.  I think it's safe to assume that if you don't have an LAPIC
-- an ancient system by now -- you have port 70h.

	-hpa

