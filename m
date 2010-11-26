Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010Ab0KZQ0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:26:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:51898 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab0KZQ0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:26:43 -0500
Message-ID: <4CEFDF89.3000500@kernel.org>
Date: Fri, 26 Nov 2010 17:25:45 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [thiscpuops upgrade 02/10] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
References: <20101123235139.908255844@linux.com> <20101123235157.062638491@linux.com>
In-Reply-To: <20101123235157.062638491@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 16:25:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 12:51 AM, Christoph Lameter wrote:
> this cpu operations can be used to slightly optimize the function. The
> changes will avoid some address calculations and replace them with the
> use of the percpu segment register.
> 
> If one would have this_cpu_inc_return and this_cpu_dec_return then it
> would be possible to optimize inc_zone_page_state and dec_zone_page_state even
> more.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Looks correct to me but it would be nice to run this through sparse.

Thanks.

-- 
tejun
