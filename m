Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2ACHvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:51:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43210 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2ACHvk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:51:40 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, "Gilad Ben-Yossef" <gilad@benyossef.com>
Cc: "Chris Metcalf" <cmetcalf@tilera.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Russell King" <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        "Pekka Enberg" <penberg@kernel.org>, "Matt Mackall" <mpm@selenic.com>,
        "Rik van Riel" <riel@redhat.com>, "Andi Kleen" <andi@firstfloor.org>,
        "Sasha Levin" <levinsasha928@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, "Avi Kivity" <avi@redhat.com>
Subject: Re: [PATCH v5 1/8] smp: Introduce a generic on_each_cpu_mask function
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
 <1325499859-2262-2-git-send-email-gilad@benyossef.com>
Date: Tue, 03 Jan 2012 08:51:15 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v7hz3pbc3l0zgt@mpn-glaptop>
In-Reply-To: <1325499859-2262-2-git-send-email-gilad@benyossef.com>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jan 2012 11:24:12 +0100, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> @@ -102,6 +102,13 @@ static inline void call_function_init(void) { }
>  int on_each_cpu(smp_call_func_t func, void *info, int wait);
> /*
> + * Call a function on processors specified by mask, which might include
> + * the local one.
> + */
> +void on_each_cpu_mask(const struct cpumask *mask, void (*func)(void *),
> +		void *info, bool wait);
> +

on_each_cpu() returns an int.  For consistency reasons, would it make sense to
make on_each_cpu_maks() to return and int?  I know that the difference is that
smp_call_function() returns and int and smp_call_function_many() returns void,
but to me it actually seems strange and either I'm missing something important
(which is likely) or this needs to get cleaned up at one point as well.

> +/*
>   * Mark the boot cpu "online" so that it can call console drivers in
>   * printk() and can access its per-cpu storage.
>   */

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
