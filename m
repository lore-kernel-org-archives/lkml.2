Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1ITV6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:58:36 -0400
Received: from n1.taur.dk ([217.198.219.102]:56103 "EHLO n1.taur.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1ITV6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:58:35 -0400
Message-ID: <4E790C5E.5000000@kasperkp.dk>
Date: Tue, 20 Sep 2011 23:57:50 +0200
From: Kasper Pedersen <kernel@kasperkp.dk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110831 Fedora/3.1.12-2.fc14 Thunderbird/3.1.12
MIME-Version: 1.0
To: Jesse Gross <jesse@nicira.com>
CC: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tg3: fix VLAN tagging regression
References: <4E78FC38.7040903@kasperkp.dk> <20110920210929.GA9652@mcarlson.broadcom.com> <CAEP_g=9V=5zHqwz710TSuRSqTdo1kqkKF2VEEV6K3Tv1zupegg@mail.gmail.com>
In-Reply-To: <CAEP_g=9V=5zHqwz710TSuRSqTdo1kqkKF2VEEV6K3Tv1zupegg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 11:27 PM, Jesse Gross wrote:

> On Tue, Sep 20, 2011 at 2:09 PM, Matt Carlson <mcarlson@broadcom.com> wrote:
>> On Tue, Sep 20, 2011 at 01:48:56PM -0700, Kasper Pedersen wrote:
>>> commit 92cd3a17ce9c719abb4c28dee3438e0c641f8de4
>>>     tg3: Simplify tx bd assignments
>>>
>>> broke VLAN tagging on outbound packets.
>>> It ifdef'ed BCM_KERNEL_SUPPORTS_8021Q, but this
>>> is not set anywhere. So vlan never gets set, and
>>> all packets are sent with vlan=0.
>>>
>>> Change to use the CONFIG_VLAN_xxx defines instead.
>>> Tested on BCM5721 rev 11.
>>>
>>> Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
>>
>> Yes.  This is correct.
>>
>> Acked-by: Matt Carlson <mcarlson@broadcom.com>
> 
> Actually, please don't do this.  Those config #define's refer to the
> 802.1q module that creates vlan devices only.  The rest of the network
> stack has code for dealing with vlan packets that is not protected by
> config guards, so there's no reason that drivers should be.  The
> correct thing to do here is just drop the test altogether and
> unconditionally include the code.
> 


currently testing, and will post a just-remove-ifdef in a few hours,
assuming it behaves as expected on a no-802.1q-module config.


tg3 has one more place where this is done, and it looks as if the code
in that location doesn't quite mesh with the comment.

/Kasper Pedersen
