Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab2EAM4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 08:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab2EAM4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 08:56:30 -0400
Message-ID: <4F9FDD75.4030608@redhat.com>
Date: Tue, 01 May 2012 15:56:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: Re: [PATCH] kvm: fix cpuid eax
References: <20120430143902.GA10181@redhat.com> <4F9EF7FA.3060007@codemonkey.ws> <4F9FDCC4.3030302@redhat.com>
In-Reply-To: <4F9FDCC4.3030302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2012 03:53 PM, Avi Kivity wrote:
> On 04/30/2012 11:37 PM, Anthony Liguori wrote:
> > On 04/30/2012 09:39 AM, Michael S. Tsirkin wrote:
> >> cpuid eax should return the max leaf so that
> >> guests can find out the valid range.
> >> This matches Xen et al.
> >
> > What KVM does here predates Xen and Hyper-V.
> >
> > This is an ABI breaker.
>
> First, I don't think we ever documented eax, so nothing can rely on it.
>

Actually, we did document it.

However, I think it's safe to change.  The documentation in this case
should say "reserved, returns zero in this implementation", rather than 0.

-- 
error compiling committee.c: too many arguments to function

