Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0LGOcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:32:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:52615 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0LGOco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:32:44 -0500
Message-ID: <4CFE454C.3010908@kernel.org>
Date: Tue, 07 Dec 2010 15:31:40 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Neil Horman <nhorman@tuxdriver.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 06/11] drivers: Replace __get_cpu_var with __this_cpu_read
 if not used for an address.
References: <20101206171618.302060721@linux.com> <20101206171639.749599301@linux.com>
In-Reply-To: <20101206171639.749599301@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 14:31:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> __get_cpu_var() can be replaced with this_cpu_read and will then use a single
> read instruction with implied address calculation to access the correct per cpu
> instance.
> 
> However, the address of a per cpu variable passed to __this_cpu_read() cannot be
> determed (since its an implied address conversion through segment prefixes).
> Therefore apply this only to uses of __get_cpu_var where the addres of the
> variable is not used.
> 
> V3->V4:
> 	- Move one instance of this_cpu_inc_return to a later patch
> 	  so that this one can go in without percpu infrastructrure
> 	  changes.
> 
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

applied.

-- 
tejun
