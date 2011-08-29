Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1H2PJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:09:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25045 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1H2PJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:09:29 -0400
MIME-Version: 1.0
Message-ID: <4724822e-3798-4837-aba3-e87d191bd40e@default>
Date: Mon, 29 Aug 2011 08:08:32 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Nebojsa Trpkovic <trx.lists@gmail.com>
Cc: linux-kernel@vger.kernel.org, Konrad Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: cleancache can lead to serious performance degradation
References: <4E4C395E.20000@gmail.com> <20110825041212.GA5014@dumpdata.com>
 <3aef71a8-d390-4a91-bfef-561c89edc040@default 4E5AE138.20408@gmail.com>
In-Reply-To: <4E5AE138.20408@gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E5BAB7E.013C:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nebojsa Trpkovic [mailto:trx.lists@gmail.com]
> Subject: Re: cleancache can lead to serious performance degradation
> 
> Thank you everybody for reviewing my report.

Thanks for reporting it!  To paraphrase Clint Eastwood:

"A kernel developer's got to know his patchset's limitations".

(Clint said "A man's got to know his limitations" in Magnum Force, 1973.)

> I've noticed performance degradation during the real workload. I did not
> run any special benchmarks to prove this problem. All my conclusions are
> based on everyday usage case scenarios.
> 
> I use multi-purpose (read: all-purpose) server with Intel Core 2 Duo
> E6550, 8GB DDR2, 4 1Gbps NICs and 16 1.5TB 5.4k rpm hard drives in LAN
> with ~50 workstations and WAN with couple of hundreds clients.

<snip>

OK, so the old CPU is mostly acting as a fancy router between 16 spindles
and 4 fast NICs to transfer very large "packets" (sequential files).
I can see how that kind of workload would not be kind to zcache,
though a more modern multi-core (4-core i7?) might handle it better.
And, as suggested earlier in this thread, a faster-but-less-space-efficient
compression algorithm would be useful too, along with some policy
that senses when 

> Last but not least, thank you for developing such a great feature for
> Linux kernel!

Thanks!  Many people contributed (especially Nitin Gupta).  I hope other
users and workloads have better luck with it than you/yours does!

> Best Regards,
> Nebojsa Trpkovic

Thanks,
Dan
