Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0JTLgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 07:36:43 -0400
Received: from david.siemens.de ([192.35.17.14]:15483 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab0JTLgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 07:36:42 -0400
Message-ID: <4CBED41F.6030109@siemens.com>
Date: Wed, 20 Oct 2010 13:35:59 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "riel@redhat.com" <riel@redhat.com>,
        "cl@linux-foundation.org" <cl@linux-foundation.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH v7 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1287048176-2563-1-git-send-email-gleb@redhat.com> <1287048176-2563-3-git-send-email-gleb@redhat.com> <4CBED271.9000103@siemens.com> <20101020113300.GR10207@redhat.com>
In-Reply-To: <20101020113300.GR10207@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.10.2010 13:33, Gleb Natapov wrote:
> On Wed, Oct 20, 2010 at 01:28:49PM +0200, Jan Kiszka wrote:
>>
>> Based on early kvm-kmod experiments, it looks like this (and maybe more)
>> breaks the build in arch/x86/kvm/x86.c if CONFIG_KVM_ASYNC_PF is
>> disabled. Please have a look.
>>
> CONFIG_KVM_ASYNC_PF is always enabled on x86.

Ah, so this is more like CONFIG_HAVE_KVM_ASYNC_PF?

Then I need some stubs in kvm-kmod to handle the case that its disabled
on x86 (due to missing host kernel features).

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
