Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326Ab0HFM5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:57:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38682 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759248Ab0HFM5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:57:19 -0400
Message-ID: <4C5C06A6.7070206@kernel.org>
Date: Fri, 06 Aug 2010 14:57:10 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] percpu: remove address_space attribute if !SMP
References: <1281098768-5724-1-git-send-email-namhyung@gmail.com>	 <4C5C04D8.1080103@kernel.org> <1281099197.1655.11.camel@leonhard>
In-Reply-To: <1281099197.1655.11.camel@leonhard>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 12:57:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/06/2010 02:53 PM, Namhyung Kim wrote:
>> But they should still be accessed through the accessors and if they
>> are accessed through accessors, there shouldn't be sparse warnings
>> regarding them.  Maybe UP accessors are missing proper markups?  Do
>> those warnings only happen on UP config?
>>
> 
> They do nothing on UP.
> quoting from include/asm-generic.h:
> 
> #else /* ! SMP */
> 
> #define per_cpu(var, cpu)			(*((void)(cpu), &(var)))
> #define __get_cpu_var(var)			(var)
> #define __raw_get_cpu_var(var)			(var)
> #define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
> #define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
> 
> #endif	/* SMP */

Ah, I see.  Then, the right thing to do is to add proper checking and
markups to UP accessors matching the SMP ones.
ie. __verify_pcpu_ptr() verification followed by __kernel __force
casting.  Are you interested in doing it?

Thanks.

-- 
tejun
