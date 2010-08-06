Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761229Ab0HFMx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 08:53:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64490 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162Ab0HFMxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 08:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N8HJoaTdSiNFy5Q3bWflabWtQU/VvpNPSgeY4oe7kCSlyu0dnDSPvFDpy8jscjh9Uv
         c++tQ8ZoPajbT2B3Z7/1ypq5kUXEiPAmExIvAXFR7/ET1OKkYsO91j7uuTqshiZjhu09
         4nYcOVft4P8e2H8dMPo5R81agdXcTLvmqg3zc=
Subject: Re: [PATCH] percpu: remove address_space attribute if !SMP
From: Namhyung Kim <namhyung@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <4C5C04D8.1080103@kernel.org>
References: <1281098768-5724-1-git-send-email-namhyung@gmail.com>
	 <4C5C04D8.1080103@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 21:53:17 +0900
Message-ID: <1281099197.1655.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-06 (금), 14:49 +0200, Tejun Heo:
> On 08/06/2010 02:46 PM, Namhyung Kim wrote:
> > percpu data has no special meaning in case of !CONFIG_SMP.
> > This removes lots of sparse warnings.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> But they should still be accessed through the accessors and if they
> are accessed through accessors, there shouldn't be sparse warnings
> regarding them.  Maybe UP accessors are missing proper markups?  Do
> those warnings only happen on UP config?
> 

They do nothing on UP.
quoting from include/asm-generic.h:

#else /* ! SMP */

#define per_cpu(var, cpu)			(*((void)(cpu), &(var)))
#define __get_cpu_var(var)			(var)
#define __raw_get_cpu_var(var)			(var)
#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)

#endif	/* SMP */


-- 
Regards,
Namhyung Kim


