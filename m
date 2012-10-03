Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2JCSee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:34:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42179 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab2JCSed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:34:33 -0400
Message-ID: <506C8525.4060506@zytor.com>
Date: Wed, 03 Oct 2012 11:34:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org> <1348991844-12285-5-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com> <20121003165105.GA30214@jshin-Toonie>
In-Reply-To: <20121003165105.GA30214@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2012 09:51 AM, Jacob Shin wrote:
>
> Any comments, thoughts? hpa? Yinghai?
>
> So it seems that during init_memory_mapping Xen needs to modify page table
> bits and the memory where the page tables live needs to be direct mapped at
> that time.
>
> Since we now call init_memory_mapping for every E820_RAM range sequencially,
> the only way to satisfy Xen is to find_early_page_table_space (good_end needs
> to be within memory already mapped at the time) for every init_memory_mapping
> call.
>
> What do you think Yinghai?
>

I outlined the sane way to do this at Kernel Summit for Yinghai and 
several other people.  I need to write it up for people who weren't 
there, but I don't have time right at the moment.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

