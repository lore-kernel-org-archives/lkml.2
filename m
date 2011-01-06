Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab1AFWGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:06:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34331 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab1AFWG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:06:29 -0500
Message-ID: <4D263C91.30709@zytor.com>
Date: Thu, 06 Jan 2011 14:05:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for this_cpu_cmpxchg_double
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com>
In-Reply-To: <20110106204525.222395863@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 12:45 PM, Christoph Lameter wrote:
> Introduce this_cpu_cmpxchg_double. this_cpu_cmpxchg_double() allows the
> comparision between two consecutive words and replaces them if there is
> a match.
> 
> 	bool this_cpu_cmpxchg_double(pcp1, pcp2,
> 		old_word1, old_word2, new_word1, new_word2)
> 
> this_cpu_cmpxchg_double does not return the old value (difficult since
> there are two words) but a boolean indicating if the operation was
> successful.
> 
> The first percpu variable must be double word aligned!

I really truly hate this interface.  The whole notion of passing two
pointers where only one is really used, is just painful.

	-hpa
