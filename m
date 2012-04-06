Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab2DFRrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:47:42 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:49358
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756856Ab2DFRrk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:47:40 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz9371I1432N98dK179dNzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M22K34-02-75U-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Topic: semaphore and mutex in current Linux kernel (3.2.2)
Thread-Index: Ac0P7b5dm37XnMCsR726LS+rxvQKd///odaAgANgVTOAA464hf/+uc3QgAIOroD//vwc0A==
Date: Fri, 6 Apr 2012 17:47:28 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0439F94AB@SCYBEXDAG02.amd.com>
 <20120401121943.GA11893@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9560@SCYBEXDAG02.amd.com>
 <20120403075245.GD26826@gmail.com>
 <491D6B4EAD0A714894D8AD22F4BDE0439F98F4@SCYBEXDAG02
 <4F7DA8FD.1020909@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9E45@SCYBEXDAG02.amd.com>
 <4F7EC111.4010608@ladisch.de>
In-Reply-To: <4F7EC111.4010608@ladisch.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 6:10 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> Chen, Dennis (SRDC SW) wrote:
>> On Thu, Apr 5, 2012 at 10:15 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
>>
>> I guess this is related with RCU component, but I don't found the right place where the code
>> Located yet.
>
> "On the internet, nobody can hear you being subtle."
>
> If some other process wants to run on the same CPU, needs_resched() is set.
> (This might happen to make the cursor blink, for keyboard input, or when
> somebody starts a rogue process like ps.)
>

Hmm, I forget that in each timer interrupt, __rcu_pending() will be called, it will call
set_need_resched() to set the TIF_NEED_RESCHED in some condition...
The optimization of mutex work closely with rcu, so fantastic!

