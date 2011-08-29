Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1H2WIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:08:41 -0400
Received: from mx2.netapp.com ([216.240.18.37]:62696 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1H2WIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:08:39 -0400
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="576100319"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 19/24] sunrpc: Remove unnecessary OOM logging messages
Date: Mon, 29 Aug 2011 15:08:41 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430AEB4F23@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <4E5C0AB3.90401@panasas.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 19/24] sunrpc: Remove unnecessary OOM logging messages
Thread-Index: Acxml1JfcA/VKaluRgWxu99/XlnuwgAAGjYw
References: <cover.1314650069.git.joe@perches.com> <8a6378b3fef105983db001fb720c84b669491439.1314650069.git.joe@perches.com> <2E1EB2CF9ED1CB4AA966F0EB76EAB4430AEB4EE9@SACMVEXC2-PRD.hq.netapp.com> <20110829.143751.1153162956919885670.davem@davemloft.net> <4E5C0AB3.90401@panasas.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>,
        "David Miller" <davem@davemloft.net>
Cc: <joe@perches.com>, <bfields@fieldses.org>, <neilb@suse.de>,
        <linux-nfs@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Aug 2011 22:08:38.0607 (UTC) FILETIME=[3456D5F0:01CC6698]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7TM8sZa020700

> -----Original Message-----
> From: Boaz Harrosh [mailto:bharrosh@panasas.com]
> Sent: Monday, August 29, 2011 5:55 PM
> To: David Miller
> Cc: Myklebust, Trond; joe@perches.com; bfields@fieldses.org;
> neilb@suse.de; linux-nfs@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 19/24] sunrpc: Remove unnecessary OOM logging
> messages
> 
> On 08/29/2011 02:37 PM, David Miller wrote:
> > From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
> > Date: Mon, 29 Aug 2011 14:36:17 -0700
> >
> >> Big NACK...
> >>
> >> By whose standard are those "not useful"?
> >
> > By mine, that's for sure.  It's duplicating something that the
> allocation
> > layers are already going to print.
> 
> I have a question about that. Are the dprints going to show the stack
> backtrace?
> Otherwise how can I see which exact allocation failed and was not
> properly handled?
> 
> If yes above? then I'm not sure I like it either, because am I'll be
> getting a full
> stack backtrace for every failed allocation?
> 
> But I might like it if I try. How do I turn on allocation failures
> prints?
> Can I filter out to print only GFP_KERNEL failures and or other GFP
> combinations?

Right. If every GFP_ATOMIC or GFP_NOWAIT is going to print out stack traces, then we're heading for absolute insanity. If not, then the existing dprintk()s make a lot more sense, 'cos they are turned on only when the administrator notices a problem, and is trying to debug it.

Trond

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
