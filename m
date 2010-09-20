Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0ITXIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:08:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:49244 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab0ITXII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:08:08 -0400
Message-ID: <4C97E9A6.6030909@kernel.org>
Date: Tue, 21 Sep 2010 01:09:26 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: caiqian@redhat.com
CC: graff yang <graff.yang@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kexec <kexec@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        sonic adi <sonic.adi@gmail.com>,
        Chris Lalancette <clalance@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: kvm kdump regression
References: <1841599922.1349991284977843873.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1841599922.1349991284977843873.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 20 Sep 2010 23:07:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks a lot for testing.  Can you please verify whether the following
patch fixes the problem?

diff --git a/mm/percpu.c b/mm/percpu.c
index 58c572b..c76ef38 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1401,9 +1401,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,

 			if (pcpu_first_unit_cpu == NR_CPUS)
 				pcpu_first_unit_cpu = cpu;
+			pcpu_last_unit_cpu = cpu;
 		}
 	}
-	pcpu_last_unit_cpu = cpu;
 	pcpu_nr_units = unit;

 	for_each_possible_cpu(cpu)
