Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0IGJOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 05:14:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab0IGJOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 05:14:31 -0400
Message-ID: <4C860255.7000707@redhat.com>
Date: Tue, 07 Sep 2010 12:13:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <1283772256.1930.303.camel@laptop>	<4C84D1CE.3070205@redhat.com>	<1283774045.1930.341.camel@laptop>	<4C84D77B.6040600@redhat.com>	<20100906124330.GA22314@elte.hu>	<4C84E265.1020402@redhat.com>	<20100906125905.GA25414@elte.hu>	<4C850147.8010908@redhat.com>	<20100906154737.GA4332@elte.hu>	<4C852B2A.2030103@redhat.com>	<20100907034417.GA14046@elte.hu> <AANLkTik0d=d4VfWy0WFDpsQttbZ9cFTVjqmRjgY4+7v1@mail.gmail.com>
In-Reply-To: <AANLkTik0d=d4VfWy0WFDpsQttbZ9cFTVjqmRjgY4+7v1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/07/2010 11:33 AM, Stefan Hajnoczi wrote:
>
> Native Client: A Sandbox for Portable, Untrusted x86 Native Code, IEEE
> Symposium on Security and Privacy, May 2009
> http://nativeclient.googlecode.com/svn/data/docs_tarball/nacl/googleclient/native_client/documentation/nacl_paper.pdf
>
> The "Inner Sandbox" they talk about verifies a subset of x86 code.
> For indirect control flow (computed jumps), they introduce a new
> instruction that can do run-time checking of the destination address.

Interesting, but appears to rely on x86 segmentation, which isn't 
available on x86_64.

Removing that requirement means replacing indirect memory access by a 
new instruction that does run-time checking, like indirect control flow, 
which is likely to kill performance.

-- 
error compiling committee.c: too many arguments to function

