Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0HOQIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 12:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143Ab0HOQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 12:08:34 -0400
Message-ID: <4C67CA94.60501@redhat.com>
Date: Sun, 15 Aug 2010 14:08:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Sheng Yang <sheng@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] kvm: fix poison overwritten caused by using wrong xstate
 size
References: <AANLkTikx35Sp0GR4c_REYGcZV4bMgS+T-1cugen45d58@mail.gmail.com> <1281683951-19814-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1281683951-19814-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/13/2010 10:19 AM, Xiaotian Feng wrote:
> fpu.state is allocated from task_xstate_cachep, the size of task_xstate_cachep
> is xstate_size. xstate_size is set from cpuid instruction, which is often
> smaller than sizeof(struct xsave_struct). kvm is using sizeof(struct xsave_struct)
> to fill in/out fpu.state.xsave, as what we allocated for fpu.state is
> xstate_size, kernel will write out of memory and caused poison/redzone/padding
> overwritten warnings.

Thanks, applied.

-- 
error compiling committee.c: too many arguments to function

