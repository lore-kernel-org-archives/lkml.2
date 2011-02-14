Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1BNNBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:01:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54545 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1BNNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:01:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=C+hWB2Aof37xOLi8SWuN+D3QsDtf/f4yCxcLrNGhRYytyr/7CUmq/rS7PpgnfvBVBr
         yaKwVZXs7QRxIWbPnzmV38e1K+eUwZ+dd9XuEFN1dnXd5KJVv4CjWr2N84NIHx/NvOBL
         7QYK5+DuuRaccybcS4xWMNK8mujh9ebSBXTgM=
Message-ID: <4D5927B8.2070704@gmail.com>
Date: Mon, 14 Feb 2011 14:01:44 +0100
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <therbert@google.com>, Changli Gao <xiaosuo@gmail.com>,
        Jesse Gross <jesse@nicira.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] core: dev: don't call BUG() on bad input
References: <1297680967-11893-1-git-send-email-segoon@openwall.com> <4D591D04.4050000@gmail.com> <20110214122313.GA10062@albatros>
In-Reply-To: <20110214122313.GA10062@albatros>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/02/2011 13:23, Vasiliy Kulikov a écrit :
> Hi Nicolas,

Hi Vasiliy,

> On Mon, Feb 14, 2011 at 13:16 +0100, Nicolas de Pesloüan wrote:
>>> -	BUG_ON(strlen(name)>= sizeof(dev->name));
>>> +	if (strnlen(name, sizeof(dev->name))>= sizeof(dev->name)) {
>
> Ehh...  Space after ")" is needed :)

:-D

>> "size_t strnlen(const char *s, size_t maxlen) : The strnlen()
>> function returns strlen(s), if that is less than maxlen, or maxlen
>> if there is no '\0' character among the first maxlen characters
>> pointed to by s."
>>
>> How can strnlen(name, sizeof(dev->name)) be greater than sizeof(dev->name)?
>>
>> Shouldn't it be "if (strnlen(name, sizeof(dev->name)) == sizeof(dev->name))" instead?
>
> Not a big deal, but MO it's better to guard from everything that
> is not a good input by negating the check.  strnlen()<  sizeof() is OK,
> strnlen()>= sizeof() is bad.  Is "==" more preferable for net/ coding style?

Agreed, both cannot cause any troubles. == is supposed to be better from the API point of view, but 
 >= is probably more readable.

	Nicolas.
