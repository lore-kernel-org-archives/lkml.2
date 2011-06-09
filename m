Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab1FIDN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:13:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49243 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1FIDNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:13:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gwt09n0+2//ZTdrD8bXjjsUT53NeV8zUI0OIakCJI0yIUvjk8RFkbKUcjgE5PIcaAH
         rxa8c7dY7aTXKLP+4NkKlTg2ar0diqYgaLv2BRepGOv8qlR4DifrBcS18ADBA1ldrEfH
         jF1Oc39phb/+nIyloiEwhp3JUY1/a8VdBrevk=
MIME-Version: 1.0
In-Reply-To: <4DF03894.2090202@gmail.com>
References: <1307413455-6942-1-git-send-email-panweiping3@gmail.com>
	<4DF03894.2090202@gmail.com>
Date: Thu, 9 Jun 2011 11:13:54 +0800
Message-ID: <BANLkTimb-ankqNPyvcJMJY24zf9hB5AgOQ@mail.gmail.com>
Subject: Re: [PATCH] bonding: use new value of lacp_rate and ad_select
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: WeipingPan <panweiping3@gmail.com>
Cc: jpirko@redhat.com, Jay Vosburgh <fubar@us.ibm.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "<netdev@vger.kernel.org>, open list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 9, 2011 at 11:05 AM, WeipingPan <panweiping3@gmail.com> wrote:
> On 06/07/2011 10:24 AM, Weiping Pan wrote:
>>
>> There is bug that when you modify lacp_rate via sysfs,
>> 802.3ad won't use the new value of lacp_rate to transmit packets.
>> This is because port->actor_oper_port_state isn't changed.
>>
>> As for ad_select, it can work,
>> but both struct bond_params and ad_bond_info have lacp_fast and ad_select,
>> they are duplicate and need extra synchronization.
>> 802.3ad can get them from bond_params directly every time.
>>
> Any comments ?
>

I think you'd better separate bug fix from cleanup's.
