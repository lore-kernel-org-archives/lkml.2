Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102Ab2EIP4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:56:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41914 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758178Ab2EIP4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:56:07 -0400
Message-ID: <4FAA938A.1030003@zytor.com>
Date: Wed, 09 May 2012 08:55:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Ido Yariv <ido@wizery.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shai Fultheim <shai@scalemp.com>
Subject: Re: [PATCH v4] vsmp: Fix number of CPUs when vsmp is disabled
References: <20120509082225.GB5036@NoteStation.colubris.lan> <1336552121-6742-1-git-send-email-ido@wizery.com> <20120509154448.GD2653@gmail.com>
In-Reply-To: <20120509154448.GD2653@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 08:44 AM, Ingo Molnar wrote:
> 
> * Ido Yariv <ido@wizery.com> wrote:
> 
>> +static void __init vsmp_cap_cpus(void)
>> +{
>> +	void __iomem *address;
>> +	unsigned int cfg, topology, node_shift, maxcpus;
>> +
>> +#ifdef CONFIG_X86_VSMP
>> +	/* VSMP is enabled, no need to cap cpus */
>> +	return;
>> +#elif defined(CONFIG_SMP)
>> +	/*
>> +	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to the
> 
> I suspect this will throw compiler warnings in the 
> CONFIG_X86_VSMP && !CONFIG_SMP case.
> 

What on Earth is the point of allowing that combination?  Why not make
X86_VSMP depend on SMP and reduce the testing matrix?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

