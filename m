Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1KOS1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:27:18 -0500
Received: from mx2.parallels.com ([64.131.90.16]:52088 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133Ab1KOS1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:27:17 -0500
From: James Bottomley <jbottomley@parallels.com>
To: "davem@davemloft.net" <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC: Glauber Costa <glommer@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "paul@paulmenage.org" <paul@paulmenage.org>,
        "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "gthelen@google.com" <gthelen@google.com>,
        "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Devel] Re: [PATCH v5 00/10] per-cgroup tcp memory pressure
Thread-Topic: [Devel] Re: [PATCH v5 00/10] per-cgroup tcp memory pressure
Thread-Index: AQHMnwoe/tNxcSeG/k+9cSl8OOkvX5Wu0GoA
Date: Tue, 15 Nov 2011 18:27:12 +0000
Message-ID: <1321381632.3021.57.camel@dabdike.int.hansenpartnership.com>
References: <1320679595-21074-1-git-send-email-glommer@parallels.com>
	 <4EBAC04F.1010901@parallels.com>
In-Reply-To: <4EBAC04F.1010901@parallels.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [76.243.235.53]
Content-Type: text/plain; charset="utf-8"
Content-ID: <1EAD5527F120CB4E80CCB5C5CB27495B@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAFIRVGW025131

On Wed, 2011-11-09 at 16:02 -0200, Glauber Costa wrote:
> On 11/07/2011 01:26 PM, Glauber Costa wrote:
> > Hi all,
> >
> > This is my new attempt at implementing per-cgroup tcp memory pressure.
> > I am particularly interested in what the network folks have to comment on
> > it: my main goal is to achieve the least impact possible in the network code.
> >
> > Here's a brief description of my approach:
> >
> > When only the root cgroup is present, the code should behave the same way as
> > before - with the exception of the inclusion of an extra field in struct sock,
> > and one in struct proto. All tests are patched out with static branch, and we
> > still access addresses directly - the same as we did before.
> >
> > When a cgroup other than root is created, we patch in the branches, and account
> > resources for that cgroup. The variables in the root cgroup are still updated.
> > If we were to try to be 100 % coherent with the memcg code, that should depend
> > on use_hierarchy. However, I feel that this is a good compromise in terms of
> > leaving the network code untouched, and still having a global vision of its
> > resources. I also do not compute max_usage for the root cgroup, for a similar
> > reason.
> >
> > Please let me know what you think of it.
> 
> Dave, Eric,
> 
> Can you let me know what you think of the general approach I've followed 
> in this series? The impact on the common case should be minimal, or at 
> least as expensive as a static branch (0 in most arches, I believe).
> 
> I am mostly interested in knowing if this a valid pursue path. I'll be 
> happy to address any specific concerns you have once you're ok with the 
> general approach.

Ping on this, please.  We're blocked on this patch set until we can get
an ack that the approach is acceptable to network people.

Thanks,

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
