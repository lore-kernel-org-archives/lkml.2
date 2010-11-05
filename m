Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0KEN3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 09:29:47 -0400
Received: from mail.asbjorn.biz ([217.195.185.3]:40568 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab0KEN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 09:29:45 -0400
Message-ID: <4CD406C7.8090801@asbjorn.biz>
Date: Fri, 05 Nov 2010 13:29:43 +0000
From: =?ISO-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <asbjorn@asbjorn.biz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: maximilian attems <max@stro.at>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: [PATCH] kbuild, deb-pkg: select userland architectire based on
 UTS_MACHINE
References: <4CD2A8BC.3010500@suse.cz> <1288960361-6407-1-git-send-email-asbjorn@asbjorn.biz> <20101105124129.GO15146@vostochny.stro.at>
In-Reply-To: <20101105124129.GO15146@vostochny.stro.at>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2010 12:41 PM, maximilian attems wrote:
> On Fri, Nov 05, 2010 at 12:32:41PM +0000, Asbjoern Sloth Toennesen wrote:
>> Instead of creating the debian package for the compiling userland,
>> create it for a userland matching the kernel thats being compiled.
>>
>> This patch supports all Lenny release architectures,
>> and Linux-based architecture candidates for Squeeze.
>>
>> If it can't find a proper Debian userspace it displays a warning,
>> and fallback to let deb-gencontrol use the host's userspace arch.
>>
>> Eg. with this patch the following make command:
>>
>> 	make ARCH=i386 deb-pkg
>>
>> will output an i386 Debian package instead of an amd64 one,
>> when run on an amd64 machine.
>>
>> Signed-off-by: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>
> 
> thank you, indeed very cool.

Thanks.

>> [...]
>> +	case "$UTS_MACHINE" in
>> +	i386|ia64|alpha|hppa)
>> +		debarch="$UTS_MACHINE" ;;
> 
> small nitpick parisc* != hppa

Right, hppa should be by it self.
