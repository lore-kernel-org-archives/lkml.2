Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab1FOW0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:26:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab1FOW0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:26:44 -0400
Date: Wed, 15 Jun 2011 18:26:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, cpufreq@vger.kernel.org, andre.przywara@amd.com,
        Mark.Langsdorf@amd.com
Subject: Re: [PATCH 1/2] [CPUFREQ] powernow-k8: Don't notify of successful
 transition if we failed.
Message-ID: <20110615222608.GA14031@dumpdata.com>
References: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
 <1308164520-14145-2-git-send-email-konrad.wilk@oracle.com>
 <20110615221636.GB9725@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615221636.GB9725@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DF9318B.009D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1112,6 +1114,9 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
> >  	}
> >  
> >  	res = transition_pstate(data, pstate);
> > +	if (res)
> > +		return res;
> 
> That's wrong because transition_pstate() returns 0 unconditionally
> (at least it does so on 3.0-rc3). But this change accidentally fixes
> a different bug because res is used uninitialized, containing stack
> garbage otherwise.
> 
> A proper fix should be to check against data->max_hw_pstate and
> check whether the entry is not CPUFREQ_ENTRY_INVALID (look at
> fill_powernow_table_pstate() for example).

Aha! I can respin a patch for that tomorrow.
> 
> I'm guessing this oops happens when powernow-k8 is loaded in the guest
> and that the actual power management is done in the hypervisor?

Yes.
