Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0IUAkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:40:21 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:48858 "EHLO
	mx02.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751831Ab0IUAkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:40:20 -0400
Date: Mon, 20 Sep 2010 20:40:13 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: graff yang <graff.yang@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        sonic adi <sonic.adi@gmail.com>,
        Chris Lalancette <clalance@redhat.com>, Avi Kivity <avi@redhat.com>
Message-ID: <1848241872.1438141285029613564.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4C97E9A6.6030909@kernel.org>
Subject: Re: kvm kdump regression
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Tejun Heo" <tj@kernel.org> wrote:

> Hello,
> 
> Thanks a lot for testing.  Can you please verify whether the
> following patch fixes the problem?
Yes, it did.
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 58c572b..c76ef38 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1401,9 +1401,9 @@ int __init pcpu_setup_first_chunk(const struct
> pcpu_alloc_info *ai,
> 
>  			if (pcpu_first_unit_cpu == NR_CPUS)
>  				pcpu_first_unit_cpu = cpu;
> +			pcpu_last_unit_cpu = cpu;
>  		}
>  	}
> -	pcpu_last_unit_cpu = cpu;
>  	pcpu_nr_units = unit;
> 
>  	for_each_possible_cpu(cpu)
