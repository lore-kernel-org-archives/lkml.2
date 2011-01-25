Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1AYIoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 03:44:05 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36376 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1AYIoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 03:44:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Dw3ojAC4kOK1QlTO8ILLdl/U9i33Bjp1wQ9zAfMg66egl6IWjVPP9WnI0OfTXYJC4l
         1GXTy6CdNJc6MFspBfyr+IfF4RB1TXhkJXNPVWWMoGchKsQfgfF5Z4qQcVQxuF6Qot0J
         WGZoJcRqNOBrAhf7qOkdRZM1XSMR10Kplm22g=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=4HkAnwGVxypjGZHkwTbBrBvKk4ZOPnHG+SVRS@mail.gmail.com>
References: <1295943748-9699-1-git-send-email-yong.zhang0@gmail.com>
	<20110125083915.GE13618@cr0.nay.redhat.com>
	<AANLkTi=4HkAnwGVxypjGZHkwTbBrBvKk4ZOPnHG+SVRS@mail.gmail.com>
Date: Tue, 25 Jan 2011 16:44:03 +0800
Message-ID: <AANLkTi=To_JsnqrEz03ia15HSWWNjxNHpa3hSOnmFZ9z@mail.gmail.com>
Subject: Re: [PATCH] net: NETCONSOLE_DYNAMIC need CONFIGFS_FS=y
From: Yong Zhang <yong.zhang0@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, nab@linux-iscsi.org,
        "David S. Miller" <davem@davemloft.net>,
        Kevin Hilman <khilman@deeprootsystems.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 4:42 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Tue, Jan 25, 2011 at 4:39 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Tue, Jan 25, 2011 at 04:22:28PM +0800, Yong Zhang wrote:
>>>With CONFIGFS_FS=m && NETCONSOLE_DYNAMIC=y, build error:
>>>
>>>drivers/built-in.o: In function `netconsole_target_put':
>>>build/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
>>>drivers/built-in.o: In function `netconsole_target_get':
>>>build/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
>>>build/drivers/net/netconsole.c:127: undefined reference to `config_item_get'
>>>drivers/built-in.o: In function `netconsole_target_put':
>>>build/drivers/net/netconsole.c:133: undefined reference to `config_item_put'
>>>drivers/built-in.o: In function `drop_netconsole_target':
>>>build/drivers/net/netconsole.c:634: undefined reference to `config_item_put'
>>>drivers/built-in.o: In function `make_netconsole_target':
>>>build/drivers/net/netconsole.c:607: undefined reference to `config_item_init_type_name'
>>>drivers/built-in.o: In function `dynamic_netconsole_init':
>>>build/drivers/net/netconsole.c:109: undefined reference to `config_group_init'
>>>build/drivers/net/netconsole.c:111: undefined reference to `configfs_register_subsystem'
>>>drivers/built-in.o: In function `dynamic_netconsole_exit':
>>>build/drivers/net/netconsole.c:116: undefined reference to `configfs_unregister_subsystem'
>>>
>>
>> Yeah, this was reported, another way to fix this is "select CONFIGFS_FS".
>> Using "select" makes you configure NETCONSOLE_DYNAMIC without caring
>> about if you have configured CONFIGFS_FS=y, which seems better.
>
> You mean commit d9f9ab51e55e36379773752ffeaac677b080d469?

That commit show "select CONFIGFS_FS" is the wrong way :(

>
> Thanks,
> Yong
>
> --
> Only stand for myself
>



-- 
Only stand for myself
