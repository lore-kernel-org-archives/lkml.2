Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0KRJtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:49:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:59772 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0KRJtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:49:13 -0500
Message-ID: <4CE4F672.1030904@kernel.org>
Date: Thu, 18 Nov 2010 10:48:34 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Kapil Arya <kapil@ccs.neu.edu>, Gene Cooperman <gene@ccs.neu.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Linux Containers <containers@lists.osdl.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com> <4CD26948.7050009@kernel.org> <20101104164401.GC10656@sundance.ccs.neu.edu> <4CD3CE29.2010105@kernel.org> <20101106053204.GB12449@count0.beaverton.ibm.com> <20101106204008.GA31077@sundance.ccs.neu.edu> <4CD5D99A.8000402@cs.columbia.edu> <20101107184927.GF31077@sundance.ccs.neu.edu> <4CD72150.9070705@cs.columbia.edu> <4CE3C334.9080401@kernel.org> <20101117153902.GA1155@hallyn.com> <4CE3F8D1.10003@kernel.org> <4CE4EE21.6050305@parallels.com>
In-Reply-To: <4CE4EE21.6050305@parallels.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 09:48:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pavel.

On 11/18/2010 10:13 AM, Pavel Emelyanov wrote:
>>> By this do you mean the very idea of having CR support in the kernel?
>>> Or our design of it in the kernel?
>>
>> The former, I'm afraid.
> 
> Can you elaborate on this please?

I think I already did that several times in this thread but here's an
attempt at summary.

* It adds a bunch of pseudo ABI when most of the same information is
  available via already established ABI.

* In a way which can only ever be used and tested by CR.  If possible,
  kernel should provide generic mechanisms which can be used to
  implement features in userland.  One of the reasons why we'd like to
  export small basic building blocks instead of full end-to-end
  solutions from the kernel is that we don't know how things will
  change in the future.  In-kernel CR puts too much in the kernel in a
  way too inflexible manner.

* It essentially adds a separate complete set of entry/exit points for
  a lot of things, which makes things more error prone and increases
  maintenance overhead across the board.

* And, most of all, there are userland implementation and
  virtualization, making the benefit to overhead ratio completely off.
  Userland implementation _already_ achieves most of what's necessary
  for the most important use case of HPC without any special help from
  the kernel.  The only reasonable thing to do is taking a good look
  at it and finding ways to improve it.

Thanks.

-- 
tejun
