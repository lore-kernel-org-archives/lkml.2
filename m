Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1ITV1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:27:51 -0400
Received: from mail-vw0-f52.google.com ([209.85.212.52]:47820 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1ITV1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110920210929.GA9652@mcarlson.broadcom.com>
References: <4E78FC38.7040903@kasperkp.dk> <20110920210929.GA9652@mcarlson.broadcom.com>
From: Jesse Gross <jesse@nicira.com>
Date: Tue, 20 Sep 2011 14:27:29 -0700
Message-ID: <CAEP_g=9V=5zHqwz710TSuRSqTdo1kqkKF2VEEV6K3Tv1zupegg@mail.gmail.com>
Subject: Re: [PATCH] tg3: fix VLAN tagging regression
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Kasper Pedersen <kernel@kasperkp.dk>, Michael Chan <mchan@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 2:09 PM, Matt Carlson <mcarlson@broadcom.com> wrote:
> On Tue, Sep 20, 2011 at 01:48:56PM -0700, Kasper Pedersen wrote:
>> commit 92cd3a17ce9c719abb4c28dee3438e0c641f8de4
>>     tg3: Simplify tx bd assignments
>>
>> broke VLAN tagging on outbound packets.
>> It ifdef'ed BCM_KERNEL_SUPPORTS_8021Q, but this
>> is not set anywhere. So vlan never gets set, and
>> all packets are sent with vlan=0.
>>
>> Change to use the CONFIG_VLAN_xxx defines instead.
>> Tested on BCM5721 rev 11.
>>
>> Signed-off-by: Kasper Pedersen <kernel@kasperkp.dk>
>
> Yes.  This is correct.
>
> Acked-by: Matt Carlson <mcarlson@broadcom.com>

Actually, please don't do this.  Those config #define's refer to the
802.1q module that creates vlan devices only.  The rest of the network
stack has code for dealing with vlan packets that is not protected by
config guards, so there's no reason that drivers should be.  The
correct thing to do here is just drop the test altogether and
unconditionally include the code.
