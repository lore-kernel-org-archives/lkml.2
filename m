Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2LKGeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 01:34:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50424 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637Ab2LKGeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 01:34:19 -0500
Message-ID: <50C6D3DF.3030209@zytor.com>
Date: Mon, 10 Dec 2012 22:34:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <1354240068-9821-6-git-send-email-fenghua.yu@intel.com> <tip-474355fe313391de2429ae225e0fb02f67ec6c31@git.kernel.org> <CAE9FiQW13Ji1wGSvFKrhY5UEArHyY5bfL5Ma37SRU9uROdPYDw@mail.gmail.com> <3E5A0FA7E9CA944F9D5414FEC6C71220470F154E@ORSMSX105.amr.corp.intel.com> <CAE9FiQXGZYZiH3eUup2UXGWkeqKjsiHk7aMTFJO7xxFkqTpBZA@mail.gmail.com> <50C6AB63.9070008@zytor.com> <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
In-Reply-To: <CAE9FiQX7sPLXOacoLakaJ1qC5UuSUbrX_g7N-oWmLYg5W-91UA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 07:55 PM, Yinghai Lu wrote:
>
> And my suggestion is: after scan and find the ucode, save it to BRK,
> so don't need to adjust
> pointer again, and don't need to copy the blob and update the pointer again.
>

That doesn't work if the microcode is replaced at runtime.  However, 
vmalloc doesn't work either since 32 bits needs any one blob to be 
physically contiguous.  I have suggested Fenghua replace it with a 
linked list of kmalloc areas, one for each blob.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

