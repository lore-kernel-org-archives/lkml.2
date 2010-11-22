Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab0KVKRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:17:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125Ab0KVKRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:17:31 -0500
Message-ID: <4CEA4334.5070106@redhat.com>
Date: Mon, 22 Nov 2010 12:17:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: MMU: abstract invalid guest pte mapping
References: <4CE63CF4.80502@cn.fujitsu.com> <4CE63DB3.9010100@cn.fujitsu.com> <4CEA37A6.8040204@redhat.com> <4CEA436D.8050202@cn.fujitsu.com>
In-Reply-To: <4CEA436D.8050202@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2010 12:18 PM, Xiao Guangrong wrote:
> >
> >  I think the order is reversed.  If !is_present_gpte(), it doesn't matter
> >  if reserved bits are set or not.
> >
>
> if !is_present_gpte()&&  is_rsvd_bits_set, then we may mark the spte notrap,
> so the guest will detect #PF with PFEC.P=PEFC.RSVD=0, but the appropriate PFEC
> is PFEC.P=0&&  PEFC.RSVD=1 ?

I think the correct PFEC is .P = .RSVD = 0, but best to check on real 
hardware to be sure.

-- 
error compiling committee.c: too many arguments to function

