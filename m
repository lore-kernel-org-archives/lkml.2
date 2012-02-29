Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031103Ab2B2RIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:08:18 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:4838
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030302Ab2B2RIQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:08:16 -0500
X-SpamScore: -20
X-BigFish: PS-20(zz9371I1be0I168aJ542M1432N1a09J98dKzz1202hzz8275bh8275dhz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:157.55.61.13;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0802HT004.namprd08.prod.outlook.com;RD:none;EFVD:NLI
From: Chris Kelly <ckelly@ozmodevices.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: build failure after merge of the final tree
 (staging tree related)
Thread-Topic: linux-next: build failure after merge of the final tree
 (staging tree related)
Thread-Index: AQHM9R9H2So6mvM4AUKIL+SJlIfCzJZRP+YAgAI76MCAAAgcgIAAmlvQ
Date: Wed, 29 Feb 2012 17:08:02 +0000
Message-ID: <57C28D85C66F5C49B9E212CBFAFDAC1F23013A86@CH1PRD0802MB115.namprd08.prod.outlook.com>
References: <20120227181303.9aa93b8a8ed02428e9310c5e@canb.auug.org.au>
	<20120227211630.GA18418@kroah.com>
	<57C28D85C66F5C49B9E212CBFAFDAC1F23010F80@CH1PRD0802MB120.namprd08.prod.outlook.com>
 <20120229185227.7f14b1863c7a5d16220bac3f@canb.auug.org.au>
In-Reply-To: <20120229185227.7f14b1863c7a5d16220bac3f@canb.auug.org.au>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.42.110.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: ozmodevices.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Many thanks for your reply. This is exactly what I needed. I have submitted a patch to fix the problem and it builds OK with the compiler you suggested below.

Kind regards
Chris Kelly

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: 29 February 2012 7:52 AM
To: Chris Kelly
Cc: Greg KH; linux-next@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (staging tree related)

Hi Chris,

On Wed, 29 Feb 2012 07:35:35 +0000 Chris Kelly <ckelly@ozmodevices.com> wrote:
>
> Hi Greg,
> 
> I believe I understand the cause of the problem and would like to 
> submit a patch to fix it. However, I am unclear on what the starting 
> point is given that the final patch was reverted from linux-next. Do I 
> assume that patch will be reapplied before the applying the new patch 
> or should I provide another patch to reapply the reverted patch? Is it 
> acceptable to submit patches generated against the head of linux-next?

Your patches are all still in Greg's tree which I merge into linux-next every day.  I have then been reverting that last patch each day.  Your patch should be against Greg's tree (or your last patch) and then when the fix is in Greg's tree, I will get it in linux-next and stop reverting the other patch.

> Before submitting the patch, I would like to test that the patch 
> really does fix the issue found by Stephen. Since it doesn't occur 
> when building for x32 or x64 then I need to setup a PowerPC 
> cross-compile tool chain. Do you have any suggestions as to where I 
> can pull a prebuilt tool chain or do I need to build directly from the GNU sources.

http://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.0/x86_64-gcc-4.6.0-nolibc_powerpc64-linux.tar.xz

That is am x86_64 hosted powerpc64 compiler suitable for building the kernel.

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

