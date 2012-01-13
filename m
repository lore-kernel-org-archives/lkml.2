Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057Ab2AMFUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 00:20:31 -0500
Received: from dgate10.ts.fujitsu.com ([80.70.172.49]:58862 "EHLO
	dgate10.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2AMFUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 00:20:30 -0500
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:CC:
   Date:Subject:Thread-Topic:Thread-Index:Message-ID:
   References:In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:acceptlanguage:
   Content-Type:Content-Transfer-Encoding:MIME-Version;
  b=WXvRB7FAopw9lAYD8lhk+bdZX2oV6WE4yF9OTz2PjApB8scpl6JCZ8iQ
   j/Ko7fgQ9lxm9s9urQbe84zHz3ODFI0ovIQEuoRjhZ4pt29zqTOs2AKuP
   QLHMcV1CpVsQwuFFqK18EPaVruJoI/2ui4HOmn7DpLU1xK5XhL9brCho+
   xWoVRT/Kw8gbQMdyhc8q7yc53oHx+hVhAwgMcr8Y0fWxq3ypDUI2fzobb
   t1I3S+Lcc8dyda3NNMe+fT4xjjAQu;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.71,501,1320620400"; 
   d="scan'208";a="98320924"
From: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
To: Avi Kivity <avi@redhat.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 13 Jan 2012 06:20:23 +0100
Subject: RE: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Topic: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Index: AczQU+dqSt+d0zibTGq30HrjxXvIgABXsy+w
Message-ID: <CB1B361E45A85849902B25342E88900501CFDCE5C966@ABGEX70E.FSC.NET>
References: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
 <1326278196.2767.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CB1B361E45A85849902B25342E88900501CFDC311187@ABGEX70E.FSC.NET>
 <4F0D71F0.4030203@redhat.com>
In-Reply-To: <4F0D71F0.4030203@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0D5LAen027174

> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com]
> Sent: Wednesday, January 11, 2012 3:27 PM
> To: Borzenkov, Andrey
> Cc: Eric Dumazet; linux-kernel@vger.kernel.org
> Subject: Re: Extermeley large PageTables over 500G on kernel 2.6.32.49
> (SLES11 SP1)
> 
> On 01/11/2012 12:52 PM, Borzenkov, Andrey wrote:
> > > If not, its normal to eat so much memory for page tables
> > >
> > > grep VmPTE /proc/*/status
> > >
> > >
> >
> > Forgive my ignorance. I thought that
> >
> > 1. PTE is 8 bytes per page, which is 4K which gives 2K per 1M of memory
> > 2. All processes sharing the same shared memory share the same page
> table
> >
> > So page table for Oracle SGA 500G would be around 1G and shared by all
> Oracle clients. Is my assumption incorrect?
> >
> 
> The second assumption is incorrect.  So fully populated the 2000
> processes would consume 2T; they just haven't accessed all the SGA yet.
> 

Does kernel ever free allocated page tables, or once allocated they stick for the process lifetime? 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
