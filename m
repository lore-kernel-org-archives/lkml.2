Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2CPTBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:01:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34403 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab2CPTBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <1331923006.4041.30.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1329744626-5036-1-git-send-email-matt@console-pimps.org>
	<tip-f75bd1837564657b21431e44243e064a77276589@git.kernel.org>
	<CAE9FiQWFpsZotawqPD4738jTayB=KOGo0W9+AT2go3GYk1v_sQ@mail.gmail.com>
	<4F45B35D.1010702@zytor.com>
	<CAE9FiQUbyYYN5orG_RyVm=P-8wNh=YsET1VzGojpFTfJPueHqA@mail.gmail.com>
	<4F471651.3080609@zytor.com>
	<4F4C3BA2.1070708@kernel.org>
	<1331116250.3539.35.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAE9FiQUoRMA_PYnOEt0ZUYXLq=hNZtDuLifT=+R72HtrwfF6AA@mail.gmail.com>
	<1331206127.3539.69.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAE9FiQVZVNARgs0rzgRpRdbSPydCXoeDat=4DLMNFcyBQuqwng@mail.gmail.com>
	<1331555916.3539.88.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAE9FiQXA4+Ubh-6QZv5bouZchR6XZjBSGwR1ox-vug01xiGveA@mail.gmail.com>
	<1331815251.15493.108.camel@mfleming-mobl1.ger.corp.intel.com>
	<CAE9FiQVWjZFA9gz43NJAKbvp7HT0oekXiRY5mPgg6O8EN5xb7g@mail.gmail.com>
	<1331923006.4041.30.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Fri, 16 Mar 2012 12:01:40 -0700
X-Google-Sender-Auth: cdZz1ZCQsy-9n1V2YnNRTCYMXug
Message-ID: <CAE9FiQUBiLwo83a+i5MF_CWaL2kpXQNwtV1xxD3dDLBObQ4xbw@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, efi: Delete efi_ioremap() and fix
 CONFIG_X86_32 oops
From: Yinghai Lu <yinghai@kernel.org>
To: Matt Fleming <matt.fleming@intel.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, mingo@redhat.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, keithp@keithp.com, rui.zhang@intel.com,
        huang.ying.caritas@gmail.com, stable@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 11:36 AM, Matt Fleming <matt.fleming@intel.com> wrote:
> On Thu, 2012-03-15 at 10:54 -0700, Yinghai Lu wrote:
>> >                if (end <= max_low_pfn << PAGE_SHIFT)
>> >                        max_low_pfn_mapped = last_pfn_mapped;
>>
>> why max_low_pfn is used here?
>
> The idea is that we only want to update max_low_pfn_mapped when we've
> mapped a region at or below max_low_pfn. This maintains compatibility
> with behaviour prior to this patch.
>
>> > The max_low_pfn checks are only for CONFIG_X86_32 so that the behaviour
>> > is the same as before this patch, i.e. we don't try to map above
>> > max_low_pfn.
>>
>> ok, to simplify the code, in setup.c you could move
>> #ifdef CONFIG_X86_64
>>         if (max_pfn > max_low_pfn) {
>>                 /* can we preseve max_low_pfn ?*/
>>                 max_low_pfn = max_pfn;
>>         }
>> #endif
>>
>> before calling new init_memory_mapping()...
>>
>> so you could remove the #idef. in init_memory_mapping.
>
> Hmm.. if we do this then max_low_pfn_mapped will be set to max_pfn on
> CONFIG_X86_64 by the time we've finished looping in
> init_memory_mapping(). This is not how things work currently. Will that
> cause a problem?

oh, before this patch could be applied, you need to make sure all
max_low_pfn_mapped reference
is removed.
current assumption is under max_low_pfn_mapped all mem is mapped.
now with this patch, that assumption is not right anymore.

Yinghai
