Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab0LGOB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:01:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:50605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0LGOB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:01:28 -0500
Message-ID: <4CFE3DF8.8080405@kernel.org>
Date: Tue, 07 Dec 2010 15:00:24 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 02/11] vmstat: Optimize zone counter modifications
 through the use of this cpu operations
References: <20101206171618.302060721@linux.com> <20101206171637.445023081@linux.com>
In-Reply-To: <20101206171637.445023081@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 14:00:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> this cpu operations can be used to slightly optimize the function. The
> changes will avoid some address calculations and replace them with the
> use of the percpu segment register.
> 
> If one would have this_cpu_inc_return and this_cpu_dec_return then it
> would be possible to optimize inc_zone_page_state and dec_zone_page_state even
> more.
> 
> V1->V2:
> 	- Fix __dec_zone_state overflow handling
> 	- Use s8 variables for temporary storage.
> 
> V2->V3:
> 	- Put __percpu annotations in correct places.
> 
> Reviewed-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>

> @@ -221,16 +223,19 @@ EXPORT_SYMBOL(mod_zone_page_state);
...
> +		__this_cpu_write(*p, - overstep);

Applied to percpu#for-next with the space after '-' removed from the
above line.

Thanks.

-- 
tejun
