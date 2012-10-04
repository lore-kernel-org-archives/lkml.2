Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab2JDQTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:19:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60716 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757077Ab2JDQTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:19:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121003165105.GA30214@jshin-Toonie>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<20121003165105.GA30214@jshin-Toonie>
Date: Thu, 4 Oct 2012 09:19:08 -0700
X-Google-Sender-Auth: pgjpOgQhKELXeEgAHWY4ECabSUo
Message-ID: <CAE9FiQW7vcwSUen_TD8tZQd6aDU2-on5_T4Bjr6aqN1bxM_5Cg@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 9:51 AM, Jacob Shin <jacob.shin@amd.com> wrote:
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

that may put the page table on near end of every ram range for next
memory range.

then kdump may have problem get big range again.

Yinghai
