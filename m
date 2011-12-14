Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab1LNQRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 11:17:19 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53971 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1LNQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 11:17:16 -0500
MIME-Version: 1.0
In-Reply-To: <201112140033.58951.ptesarik@suse.cz>
References: <201112140033.58951.ptesarik@suse.cz>
Date: Thu, 15 Dec 2011 00:17:15 +0800
Message-ID: <CAM_iQpUr3MqwWzeD4Z8KzyErEM4utT=CkpbyecPu75-QDDznHQ@mail.gmail.com>
Subject: Re: Is per_cpu_ptr_to_phys broken?
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 7:33 AM, Petr Tesarik <ptesarik@suse.cz> wrote:
> Hi folks,
>
...
>
> Now, the per_cpu_ptr_to_phys() function aligns all vmalloc addresses to a page
> boundary. This was probably right when Vivek Goyal introduced that function
> (commit 3b034b0d084221596bf35c8d893e1d4d5477b9cc), because per-cpu addresses
> were only allocated by vmalloc if booted with percpu_alloc=page, but this is
> no longer the case, because per-cpu variables are now always allocated that
> way AFAICS.
>
> So, shouldn't we add the offset within the page inside per_cpu_ptr_to_phys?
>

Hi,

Tejun already fixed this, see:

commit	a855b84c3d8c73220d4d3cd392a7bee7c83de70e
percpu: fix chunk range calculation
author	Tejun Heo <tj@kernel.org>
