Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0IHGTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 02:19:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab0IHGTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 02:19:36 -0400
Message-ID: <4C872AD7.6000604@redhat.com>
Date: Wed, 08 Sep 2010 09:19:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop> <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu> <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu> <4C850147.8010908@redhat.com> <20100906154737.GA4332@elte.hu> <4C852B2A.2030103@redhat.com> <20100907034417.GA14046@elte.hu> <20100908014409.GA17010@brick.ozlabs.ibm.com>
In-Reply-To: <20100908014409.GA17010@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/08/2010 04:44 AM, Paul Mackerras wrote:
>
> So... I would be interested to see you add the case for the MOV
> instruction. :)

x86 32-bit segmentation.

Unfortunately those are limited to i386.  With some care we could use 
them on x86_64 (temporarily switch the address space to include the 
"bytecode" and its data at the lower 4G, execute a far call to the 
bytecode, etc.

It's cumbersome though, and will make context switches to the bytecode 
quite slow.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

