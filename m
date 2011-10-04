Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab1JDRiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:38:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab1JDRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:38:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=MdJFs1mTFr9T8BztjJC+uT8pLxzLYOf5ovg96Z2DZV+1x3An1DOv6mKsQnT890DY0
	j/mACjClF+HCFCZeiWBQw==
MIME-Version: 1.0
In-Reply-To: <20110929.153259.169108824599752228.davem@davemloft.net>
References: <1317324162-21621-1-git-send-email-muralira@google.com>
	<20110929.153259.169108824599752228.davem@davemloft.net>
Date: Tue, 4 Oct 2011 10:38:06 -0700
Message-ID: <CAP3iWTTYk7tErsCVdeytdpiu0fo-7B8cNZZk0EpR_rj-VOGi-g@mail.gmail.com>
Subject: Re: [PATCH] net-proc: expose the tos values in /proc/net/[tcp|udp]
From: MuraliRaja Muniraju <muralira@google.com>
To: David Miller <davem@davemloft.net>
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I shall make the changes by exposing the tos values via the
netlink as suggested. I had a doubt is I have to modify the
inet_diag_sockid or export it via a new option. I am considering
that adding into inet_diag_sockid is better because the latter is a
bit of a over kill for a single value to be exposed and it also seems
to be logical fit.
Can you let me know your thoughts on this.

Thanks,
Murali

On Thu, Sep 29, 2011 at 12:32 PM, David Miller <davem@davemloft.net> wrote:
> From: Muraliraja Muniraju <muralira@google.com>
> Date: Thu, 29 Sep 2011 12:22:42 -0700
>
>> From: Murali Raja <muralira@google.com>
>>
>> This patch exports the tos values from the inet_sock struct
>> for tcp and udp into the /proc/net/tcp or /proc/net/udp respectively.
>> This will not pickup per packet tos changes but it will address most
>> of the cases. This is mainly useful as it would decrease reliance on
>> tcpdump and also people without root access will be able to read
>> the values.
>>
>> Signed-off-by: Murali Raja <muralira@google.com>
>
> You cannot change the layout of these files, they are parsed by userland
> problems and therefore have a fixed API.
>
> Netlink based socket dumping provides a proper, backwards compatible,
> way to extend what is reported, so please consider adding your changes
> there.
>



-- 
Thanks,
Murali
