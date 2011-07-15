Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1GONb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:31:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1GONbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:31:55 -0400
Message-ID: <4E204139.5060702@redhat.com>
Date: Fri, 15 Jul 2011 14:31:37 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
CC: NeilBrown <neilb@suse.de>, david <david@lang.hm>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com> <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com> <1310735821-sup-2589@shiny>
In-Reply-To: <1310735821-sup-2589@shiny>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 02:20 PM, Chris Mason wrote:
> Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
>> On 07/15/2011 12:34 PM, Chris Mason wrote:
> [ triggering IO retries on failed crc or other checks ]
>
>>> But, maybe the whole btrfs model is backwards for a generic layer.
>>> Instead of sending down ios and testing when they come back, we could
>>> just set a verification function (or stack of them?).
>>>
>>> For metadata, btrfs compares the crc and a few other fields of the
>>> metadata block, so we can easily add a compare function pointer and a
>>> void * to pass in.
>>>
>>> The problem is the crc can take a lot of CPU, so btrfs kicks it off to
>>> threading pools so saturate all the cpus on the box.  But there's no
>>> reason we can't make that available lower down.
>>>
>>> If we pushed the verification down, the retries could bubble up the
>>> stack instead of the other way around.
>>>
>>> -chris
>> I do like the idea of having the ability to do the verification and retries down
>> the stack where you actually have the most context to figure out what is possible...
>>
>> Why would you need to bubble back up anything other than an error when all
>> retries have failed?
> By bubble up I mean that if you have multiple layers capable of doing
> retries, the lowest levels would retry first.  Basically by the time we
> get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
> do to help.
>
> -chris

Absolutely sounds like the most sane way to go to me, thanks!

Ric

