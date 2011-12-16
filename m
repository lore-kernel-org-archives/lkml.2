Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab1LPU7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:59:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63904 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1LPU7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <4EEB8EAE.6010306@zytor.com>
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
	<4EA09EA2.3030203@zytor.com>
	<1319149574.13035.6.camel@jshin-Toonie>
	<4EE9266A.90200@zytor.com>
	<20111214231425.GA18068@jshin-Toonie>
	<20111216162004.GC18068@jshin-Toonie>
	<4EEB8320.4010809@oracle.com>
	<4EEB85F1.7050903@zytor.com>
	<CAE9FiQXTeJ2XZy-Pjwvdb4Fp5wb_XLq88tC-2M_3RbjSLk5d4A@mail.gmail.com>
	<4EEB8EAE.6010306@zytor.com>
Date: Fri, 16 Dec 2011 12:59:38 -0800
X-Google-Sender-Auth: gDbWIowPqpXilZBOBTf_YygvbIw
Message-ID: <CAE9FiQUNwK5=Nos7Ce_DS1aSXgf0WNUgE=5HXnt4E01JWYbWjQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 10:32 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Well, there are two options for memory hotplug: either we always leave
> address space that can be used for memory hotplug mapped at all times, or we
> need to track it anyway.  Either way we need to know where there regions
> are.  Am I correct that right now we always map memory hotpluggable regions,
> being below the top pfn?

in arch/x86/mm/init_64.c::arch_add_memory()
it will call init_memory_mapping to map new added memory.
and will update max_pfn_mapped, max-pfn, max_low_pfn.

Thanks

Yinghai Lu
