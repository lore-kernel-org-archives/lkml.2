Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1KCJoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 05:44:10 -0400
Received: from smtprelay0101.b.hostedemail.com ([64.98.42.101]:57840 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754452Ab1KCJoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 05:44:07 -0400
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,1ca5b82a71a85ece,d41d8cd98f00b204,t.artem@lycos.com,mingo@elte.hu:linux-kernel@vger.kernel.org:a.p.zijlstra@chello.nl:efault@gmx.de:pjt@google.com,RULES_HIT:152:355:379:541:582:599:601:945:960:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1676:1711:1730:1747:1766:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2692:2731:2857:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3353:3865:3866:3867:3868:3869:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:5007:6261:7679:7875:7901:7974:9025:9388:10004:10016:10400:11658:11914,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2519
Date: Thu, 3 Nov 2011 09:44:05 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        pjt@google.com
Message-ID: <1758553229.334475.1320313445172.JavaMail.mail@webmail11>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111103081835.GA9330@elte.hu>
Subject: Re: Re: HT (Hyper Threading) aware process scheduling doesn't work
 as it should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.163.207]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Nov 3, 2011, Ingo Molnar wrote: 
> 
> If sched_mc is set to zero then this looks like a serious load 
> balancing bug - you are perfectly right that we should balance 
> between physical packages first and ending up with the kind of 
> asymmetry you describe for any observable length is a bug.
> 
> You have not outlined your exact workload - do you run a simple CPU 
> consuming loop with no sleeping done whatsoever, or something more 
> complex?
> 
> Peter, Paul, Mike, any ideas?

Actually I am just running 4 copies of bzip2 compressor (< /dev/zero > /dev/null).

A person named ffab ffa said ( http://lkml.org/lkml/2011/11/1/11 ) that I probably
misunderstand/misinterpret physical cores. He says that cores thread siblings on
e.g., Intel Core 2600K are 0-4, 1-5, 2-6 and 3-7

and when I am running this test I have the following VCPUs distribution:

1, 6, 7, 8 (0-4, 1-5, 2-6, 7-8 - all four physical cores loaded)
1, 2, 7, 8 (0-4, 1-5, 2-6, 7-8 - all four physical cores loaded)

According to the cores thread siblings distribution the HT aware process scheduler
indeed works correctly. 

However sometimes I see this picture:

3, 4, 5, 6 (2-6, 1-5, 2-6, 7-8 - three physical cores loaded)

So, now the question is whether VCPUs quite an illogical enumeration is good for
power users as I highly doubt that 0-4, 1-5, 2-6 and 3-7 order can be easily
remembered and grasped. Besides neither top, not htop are HT aware so just by
looking at their output it gets very difficult to see and understand if the process
scheduler works as it should.
