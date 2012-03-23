Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846Ab2CWED7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:03:59 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:46441 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2CWED4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:03:56 -0400
Message-ID: <4F6BF61E.7000009@linux.vnet.ibm.com>
Date: Fri, 23 Mar 2012 12:03:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Benjamin Segall <bsegall@google.com>,
        Ranjit Manomohan <ranjitm@google.com>, Nikhil Rao <ncrao@google.com>,
        jmc@cs.unc.edu, Dhaval Giani <dhaval.giani@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] LinSched for v3.3-rc7
References: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com>
In-Reply-To: <CAPM31RL6Sk6cNR9MzW_7XDvfkMA1q6xK_mcJJaCMY8Ex___9+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12032304-5564-0000-0000-000001EFAEE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 11:58 AM, Paul Turner wrote:

> Hi All,
> 
> [ Take 2, gmail tried to a non text/plain component into the last email .. ]
> 
> Quick start version:
> 
> Available under linsched-alpha at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/pjt/linsched.git  .linsched

Hi, All

I got confused with the LinSched main loop...
My understanding is:

	while (not time up) {
		
		get all cpus whose next event is the left most
		
		for those cpus {

			simulate hres clock interrupt		
			
			process_all_softirqs() ?			

			if cpu is idle
				enter idle
			else
				check process running time
		}
	}

Wonder why we need to call process_all_softirqs which will process other
cpu's pending soft irq here?

Regards,
Michael Wang

