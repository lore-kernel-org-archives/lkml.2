Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0GKMpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 08:45:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39951 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0GKMpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 08:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=biPYeWqLzR/T+BOdzquFXDFZg5Jhf+MGFvwIDvk55MO24HbSJWYLMQeYHcRqYvGez3
         hNAKnV1OuIc6fMGg5/h/xHBOrHwPUDbpJNj4vVcTCIvxEd/26Tzio+ZNqtp4xceAhLEz
         qpDvPM/kxa1si9mTCOk8OlVthOdmyMFQp+AbE=
MIME-Version: 1.0
In-Reply-To: <20100711122708.GA3573@redhat.com>
References: <20100708222913.GA4475@redhat.com> <alpine.LSU.2.01.1007091154120.7235@obet.zrqbmnf.qr> 
	<20100711122708.GA3573@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 11 Jul 2010 20:45:01 +0800
Message-ID: <AANLkTikamhUUuoQ8EjwPn9gB4zHZkeDuzpiqd4XcN3lx@mail.gmail.com>
Subject: Re: [PATCH] netfilter: add CHECKSUM target
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, herbert.xu@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 11, 2010 at 8:27 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Fri, Jul 09, 2010 at 11:56:26AM +0200, Jan Engelhardt wrote:
>>
>> On Friday 2010-07-09 00:29, Michael S. Tsirkin wrote:
>> >
>> > include/linux/netfilter_ipv4/ipt_CHECKSUM.h |   18 +++++++
>> > net/ipv4/netfilter/Kconfig                  |   16 ++++++
>> > net/ipv4/netfilter/Makefile                 |    1 +
>> > net/ipv4/netfilter/ipt_CHECKSUM.c           |   72 +++++++++++++++++++++++++++
>>
>> New modules should use xt.
>
> I tried moving the module to xt_CHECKSUM but now
>        iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill
> does not to load the module.
> It seems that xt_request_find_target in x_tables uses the prefix 'ip' for a module.
> What am I missing?
>

You should add MODULE_ALIAS clause, i.e.

MODULE_ALIAS("ipt_CHECKSUM");

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
