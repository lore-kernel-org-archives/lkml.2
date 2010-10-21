Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0JUUXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 16:23:42 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38076 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab0JUUXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 16:23:41 -0400
Date: Thu, 21 Oct 2010 21:23:36 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Andev <debiandev@gmail.com>
Cc: linux kernel <kernelnewbies@nl.linux.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Disable L1/L2/L3 cache and MTRR
Message-ID: <20101021202336.GA3318@sucs.org>
References: <AANLkTikKFnVOFr70u_2Hdtz0mXuAEckWWUy885m_ut--@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKFnVOFr70u_2Hdtz0mXuAEckWWUy885m_ut--@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 21, 2010 at 12:21:15PM -0400, Andev wrote:
> 
> In Intel software developers manual, it is mentioned that apart from the
> above you need to disable MTRR. I did that using the following command:
> 
> echo "disable=00" >| /proc/mtrr
> 
> Now when I run some sample benchmarks they show a slowdown of almost 1000x!!
> 
> This is not reasonable since the max. The slowdown I was expecting is 200x
> considering that it will take 200 cycles to read from DRAM.

Assuming the cache was completely disabled, won't the impact be
cumulative? E.g. imagine a memory read takes one cycle from cache and
100 from main memory. If you read 5 instructions from cache that will
take 5 cycles. If you read 5 instructions from main memory that will be
5*100 so 500 cycles. If it is 10 instructions then it is 10 vs 1000 and
so on...

Are you searching for an improvement in determinism?

-- 
Sitsofe | http://sucs.org/~sits/
