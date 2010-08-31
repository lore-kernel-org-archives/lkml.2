Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab0HaIW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 04:22:27 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50642 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932248Ab0HaIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 04:22:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kt73E+naMOX0XUUrQi82ZUYCL1g//fi3IJdjxVU9b8CCiVuOXtLD4T0h5ST6ZxpDXI
         Zda3JzjywpLeGq32t08Pc1Sf3Dnb7DRhl/gIPxxosjsM3BQHB+1npSB9BN4HTrEUJImC
         c7fkbk/9D8a9zSKti9TtwIYbSiNcWD8I55b5w=
Message-ID: <4C7CBBBC.3070503@gmail.com>
Date: Tue, 31 Aug 2010 10:22:20 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: increasing memory alloted for 'init' during kernel boot.
References: <AANLkTimWnYqFSC=3kqzBVtZHwodCX=MnsViDGmJbUn_8@mail.gmail.com>
In-Reply-To: <AANLkTimWnYqFSC=3kqzBVtZHwodCX=MnsViDGmJbUn_8@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 08:49 AM, Prabhu Chawandi wrote:
> Hi all,
> 
>    Whenever the kernel starts booting, I am getting the bellow log :
> 
> Memory: 110080k/262144k available (2566k kernel code, 151952k
> reserved, 561k data, 15328k init, 0k highmem).
> 
> For 'init' on what bases this amount of memory is decided ?
> 
> Anyways I can alter it?

Nope. It's code and data inside .init, .exit and similar sections. Those
are marked by __init, __exit etc. in the code. This memory is freed
after the kernel is up and running, since this memory (code and data) is
not needed anymore.

regards,
-- 
js
