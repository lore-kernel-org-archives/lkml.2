Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2KPROn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:14:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2KPROm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:14:42 -0500
Message-ID: <50A6746D.8070506@zytor.com>
Date: Fri, 16 Nov 2012 09:14:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jacob Shin <jacob.shin@amd.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, mm: setup page table from top-down
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org> <1349827115-16600-7-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210101733220.2689@kaball.uk.xensource.com> <CAE9FiQVuU=KfMM0Q16Lddz8ZL_wzg5PLkWWK=6navQdC_j0KbA@mail.gmail.com> <alpine.DEB.2.02.1210101821540.2689@kaball.uk.xensource.com> <CAE9FiQVSMP2TpTPxEB62T-uELY-W67m6LX-qTJ7yYSEE-cOZbA@mail.gmail.com>
In-Reply-To: <CAE9FiQVSMP2TpTPxEB62T-uELY-W67m6LX-qTJ7yYSEE-cOZbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 10:38 AM, Yinghai Lu wrote:
> On Wed, Oct 10, 2012 at 10:26 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
>> On Wed, 10 Oct 2012, Yinghai Lu wrote:
>>
>> It doesn't matter whether they come from BRK or other memory: Xen
>> assumes that all the pagetable pages come from
>> pgt_buf_start-pgt_buf_top, so if you are going to use another range you
>> need to tell Xen about it.
>>
>> Alternatively, you can follow Peter's suggestion and replace the current
>> hooks with a new one with a more precise and well defined semantic.
>> Something along the lines of "this pagetable page is about to be hooked
>> into the live pagetable". Xen would use the hook to mark it RO.
>
> attached patch on top of this patch will fix the problem?
>

  	.mapping = {
-		.pagetable_reserve		= native_pagetable_reserve,
+		.mark_page_ro			= mark_page_ro_noop;
  	},

I have already objected to this naming in the past, because it describes 
an implementation ("hypervisor make readonly") as opposed to a semantic 
function "make this page permissible to use as a page table".  I would 
call it pagetable_prepare or something like that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

