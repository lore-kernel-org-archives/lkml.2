Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0KIJCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:02:10 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35348 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0KIJCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:02:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=TG20e+r4tD4BLRsRgngX5feGy8nawASA0zYIeunYD9YBzb1E3rI70nI15OkC/7JxS1
         E5K9G7tZZb2l/e4sPcOuSIo0ccr1aHBv/TezFGoumUP4tK/KeAT6plpMsq7xQGfmUER+
         Q9mUx6iYL1Iv0qAIRWp8bJfb+bpRKrRE/fpL4=
Date: Tue, 9 Nov 2010 17:06:45 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mike Waychison <mikew@google.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        simon.kagstrom@netinsight.net, davem@davemloft.net,
        nhorman@tuxdriver.com, Matt Mackall <mpm@selenic.com>,
        adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v2 12/23] netpoll: Introduce netpoll_target configs
Message-ID: <20101109090645.GG5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com>
 <20101109042732.GC5220@cr0.nay.redhat.com>
 <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:34:24AM -0800, Mike Waychison wrote:
>On Mon, Nov 8, 2010 at 8:27 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Américo Wang wrote:
>>>
>> ....
>>>
>>>So, either we need to de-modulize configfs or replace configfs API
>>>with sysfs API. Personally, I prefer the former one, I don't think
>>>configfs should be a module as long as it can provide API's
>>>for other subsystems, like debugfs.
>>>
>>
>> To clarify, I meant "as long as the API it provides can be used by
>> other core subsystems".
>>
>
>Ya, I see the problem with it being a tristate.
>
>Why not just make netconsole support being compiled in force configfs
>to be compiled in?  Or does that just set bad precedent?

That is what netconsole does now, and this is fine, since netconsole is
a module too, however, after you move that code into netpoll, then netpoll
will have a dependence on it, we will have problems.

I think we can let NETPOLL_TARGET depend on CONFIGFS_FS=y, but I still
see no reason why CONFIGFS_FS should be a module.

