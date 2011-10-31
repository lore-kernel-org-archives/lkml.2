Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1JaISi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 04:18:38 -0400
Received: from smtprelay0126.b.hostedemail.com ([64.98.42.126]:55257 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754349Ab1JaISh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 04:18:37 -0400
X-Panda: scanned!
X-Spam-Summary: 2,-1.05263,0,6fe00441d0454d08,d41d8cd98f00b204,t.artem@lycos.com,yong.zhang0@gmail.com:arjan@infradead.org:linux-kernel@vger.kernel.org:mingo@elte.hu:peterz@infradead.org,RULES_HIT:152:355:379:541:582:599:601:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1676:1711:1730:1747:1766:1792:2194:2199:2393:2525:2560:2563:2682:2685:2693:2857:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3352:3865:3866:3867:3869:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:5007:6117:6261:7679:7901:9025:9108:10004:10016:10394:10400:11658:11914,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:none,DNSBL:none,Custom_rules:0:0:0
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1891
Date: Mon, 31 Oct 2011 08:18:35 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: yong.zhang0@gmail.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        peterz@infradead.org
Message-ID: <1963557866.68748.1320049115504.JavaMail.mail@webmail05>
References: <269467866.49093.1320004632156.JavaMail.mail@webmail17>
 <20111030151256.27b2b20e@infradead.org>
 <1179048211.51348.1320013764432.JavaMail.mail@webmail17>
 <20111031031907.GB18057@zhy>
Subject: Re: Re: Re: HT (Hyper Threading) aware process scheduling doesn't
 work as it should
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.111.51]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> (Cc'ing more people)
> 
> Maybe you can also show your test case here?
> 

The test case is perfectly outlined in the first message I posted to LKML but I
can repeat it for you ( https://lkml.org/lkml/2011/10/30/106 ).

On a HT enabled completely idle system run as many different tasks as you have
real CPU cores, e.g. on an Intel Core i7 2600 CPU, that will be four tasks.

For the best performance all tasks should be attached to different physical cores.
However often the opposite behaviour can be observed, the process scheduler
binds pairs of tasks to virtual HT cores of the same physical CPU module, e.g.
in theory you should get this distribution of tasks: 1:3:5:7 but often I get this 
distribution 1:6:7:8 (three physical cores loaded instead of four) or 1:2:7:8 (two
physical cores loaded instead of four).

Artem
