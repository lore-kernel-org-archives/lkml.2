Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1IFPcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:32:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61775 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1IFPcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E663882.4050404@parrot.com>
References: <4E65DF36.6040507@parrot.com>
	<CACqU3MU9nuW+a3AJfY_PRqFH_tgaKtBJrp1pU2xpB_dHYANBXg@mail.gmail.com>
	<4E663882.4050404@parrot.com>
Date: Tue, 6 Sep 2011 11:32:00 -0400
Message-ID: <CACqU3MUC-m7AgEPG2C-V2SVKEhHxdYE8tOSFJvqO9Vq+JJEchw@mail.gmail.com>
Subject: Re: randconfig broken on choice
From: Arnaud Lacombe <lacombar@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 6, 2011 at 11:13 AM, Matthieu CASTET
<matthieu.castet@parrot.com> wrote:
> Hi,
>
> Arnaud Lacombe a écrit :
>> Hi,
>>
>> On Tue, Sep 6, 2011 at 4:52 AM, Matthieu CASTET
>> <matthieu.castet@parrot.com> wrote:
>>> Hi,
>>>
>>> I am using v3.1-rc4 and make randconfig look broken for choice.
>>> The choice config is always the same or choice entry can have more than one entry.
>>>
>> Could you includes testcases showing that behavior, please ?
> $ make randconfig
>
> $ grep -e SLUB -e SLAB -e SLOB .config
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> CONFIG_SLOB=y
> # CONFIG_FAILSLAB is not set
>
> We have 2 choice selected (SLUB and SLOB). You may run randconfig (more than one
> time to get this result).
>
ok, I reproduced it with:

while true; do
    make randconfig
    CONFIG_SLAB=; CONFIG_SLOB=; CONFIG_SLUB=
    source .config
    if [ "${CONFIG_SLAB}${CONFIG_SLOB}${CONFIG_SLUB}" != "y" ]; then
        break
    fi
    sleep 1
done

I wonder what set the flags originally...

 - Arnaud

> Matthieu
>
