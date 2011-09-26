Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab1IZIjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:39:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48568 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1IZIjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:39:04 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1317022114.9084.53.camel@twins>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	<1316940890-24138-5-git-send-email-gilad@benyossef.com>
	<1317022114.9084.53.camel@twins>
Date: Mon, 26 Sep 2011 11:39:03 +0300
Message-ID: <CAOtvUMf9Vk_e3kAbSxXH4J86f1sgouYX50wkMnahaCq+YAGEvQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:28 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
>> +static inline void inc_pcp_count(int cpu, struct per_cpu_pages *pcp, int count)
>> +{
>> +       if (unlikely(!total_cpu_pcp_count))
>
>        if (unlikely(!__this_cpu_read(total_cpu_pco_count))
>

Thanks for the feedback. I will correct this and the comment style in
the next spin of the patch.

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "
