Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2LKPsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 10:48:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33938 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2LKPsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 10:48:23 -0500
Date: Tue, 11 Dec 2012 16:48:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Shi <alex.shi@intel.com>
Cc: Alex Shi <lkml.alex@gmail.com>, rob@landley.net, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        andre.przywara@amd.com, rjw@sisk.pl, paul.gortmaker@windriver.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        vincent.guittot@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 0/18] sched: simplified fork, enable load average into LB
 and power awareness scheduling
Message-ID: <20121211154819.GC8873@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Shi <alex.shi@intel.com>, Alex Shi <lkml.alex@gmail.com>,
	rob@landley.net, mingo@redhat.com, peterz@infradead.org,
	gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
	paul.gortmaker@windriver.com, akpm@linux-foundation.org,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	pjt@google.com, vincent.guittot@linaro.org,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>,
	Arjan van de Ven <arjan@linux.intel.com>
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com>
 <CAGjg+kGAokK0oOAOJL=apkcyi_deqtHHsaJCViCz9tOMKG56bw@mail.gmail.com>
 <50C722AC.3080806@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50C722AC.3080806@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2012 at 08:10:20PM +0800, Alex Shi wrote:
> Another testing of parallel compress with pigz on Linus' git tree.
> results show we get much better performance/power with powersaving and
> balance policy:
> 
> testing command:
> #pigz -k -c  -p$x -r linux* &> /dev/null
> 
> On a NHM EP box
>          powersaving               balance   	         performance
> x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
> x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76

This looks funny: so "performance" is eating less watts than
"powersaving" and "balance" on NHM. Could it be that the average watts
measurements on NHM are not correct/precise..? On SNB they look as
expected, according to your scheme.

Also, shouldn't you have the shortest compress times with "performance"?

> 
> On a 2 sockets SNB EP box.
>          powersaving               balance   	         performance
> x = 4    190.995 /149 35          200.6 /129 38          208.561 /135 35
> x = 8    197.969 /108 46          208.885 /103 46        213.96 /108 43
> x = 16   205.163 /76 64           212.144 /91 51         229.287 /97 44

Ditto here, compress times with "performance" are not the shortest. Or
does "performance" mean something else? :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
