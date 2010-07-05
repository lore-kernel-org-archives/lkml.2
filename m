Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0GEGYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 02:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0GEGYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 02:24:10 -0400
Date: Mon, 5 Jul 2010 09:23:57 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: Re: [PATCH v2] KVM: IOAPIC: only access APIC registers one dword
 at a time
Message-ID: <20100705062357.GH4689@redhat.com>
References: <4C2D6D4B.5060309@cn.fujitsu.com>
 <4C2D95EA.6080209@np.css.fujitsu.com>
 <4C2D975A.2050704@cn.fujitsu.com>
 <4C2D9C8C.8060401@cn.fujitsu.com>
 <4C2F0CC1.6020808@redhat.com>
 <4C3155BA.4070903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3155BA.4070903@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 05, 2010 at 11:47:06AM +0800, Xiao Guangrong wrote:
> > There might be guests that use incorrect access despite the
> > documentation; if real hardware supports it, it should work.  So we need
> > to start with just a warning, and allow the access.  Later we can drop
> > the invalid access.
> 
> If the OS contravene the spec, i thinks it's the OS's bug, also, i have tested some versions
> windows/linux guests, it's no broken, can we directly drop the other wide access?
> 
If reality contradicts spec we should emulate reality. I vaguely
remember some guest using memcpy on apic page for instance.

--
			Gleb.
