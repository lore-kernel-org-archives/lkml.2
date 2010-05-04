Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab0EDRgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:36:15 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38295 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab0EDRgN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:36:13 -0400
MIME-Version: 1.0
In-Reply-To: <20100420230719.GB1432@n2100.arm.linux.org.uk>
References: <k2ncecb6d8f1004191627w3cd36450xf797f746460abb09@mail.gmail.com> 
	<20100420155122.6f2c26eb.akpm@linux-foundation.org> <20100420230719.GB1432@n2100.arm.linux.org.uk>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Tue, 4 May 2010 14:35:50 -0300
Message-ID: <n2gcecb6d8f1005041035w51dac3c8ke829a4ae8bf7f408@mail.gmail.com>
Subject: Re: Suspicious compilation warning
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 20, 2010 at 20:07, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> Well, it'll be about this number on everything using sparsemem extreme:
>
> #define SECTIONS_PER_ROOT       (PAGE_SIZE / sizeof (struct mem_section))
>
> and with only 32 sections, this is going to give a NR_SECTION_ROOTS value
> of zero.  I think the calculation of NR_SECTIONS_ROOTS is wrong.
>
> #define NR_SECTION_ROOTS        (NR_MEM_SECTIONS / SECTIONS_PER_ROOT)
>
> Clearly if we have 1 mem section, we want to have one section root, so
> I think this division should round up any fractional part, thusly:
>
> #define NR_SECTION_ROOTS        ((NR_MEM_SECTIONS + SECTIONS_PER_ROOT - 1) / SECTIONS_PER_ROOT)

Seems correct to me, Is there any idea when this gets committed?

Regards,
Marcelo.
