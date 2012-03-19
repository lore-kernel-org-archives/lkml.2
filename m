Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab2CSD0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:26:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45478 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2CSD0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:26:21 -0400
Message-ID: <4F66A753.4000004@oracle.com>
Date: Mon, 19 Mar 2012 11:26:11 +0800
From: qing gu <qing.gu@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH]: md: Initialize ctl_name field of table raid_root_table/raid_dir_table
 to avoid dump_trace info in debug kernel
References: <4F5D747D.9060508@oracle.com> <20120314125720.1bb87546@notabene.brown> <m14ntsc4k2.fsf@fess.ebiederm.org> <20120314133501.14c6f7e9@notabene.brown>
In-Reply-To: <20120314133501.14c6f7e9@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4F66A758.0085,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very thanks for the reply.

Neil

On 2012/3/14 10:35, NeilBrown wrote:
> On Tue, 13 Mar 2012 19:14:05 -0700 ebiederm@xmission.com (Eric W. Biederman)
> wrote:
>
>> NeilBrown<neilb@suse.de>  writes:
>>
>>> On Mon, 12 Mar 2012 11:58:53 +0800 qing gu<qing.gu@oracle.com>  wrote:
>>>
>>>> This patch is used to dispense trace info when system boots with debug
>>>> kernel. I have verified it on RHEL6.2&  SLES11.2. Both work fine.
>>>> In the failure case, system logs that:
>>>>
>>>>      /Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl_check_dir: failed: /dev  ref: /dev .7
> .....
>
>>> These lines were removed in November 2009 by Eric Biederman in
>>> commit 894d2491153a9f8270dbed21175d06fde4eba6c7
>>>
>>> So I'm not keen on adding them back without understanding the history.
>>>
>>> Eric:  Do we need these after all?
>> For the main trunk no.  The .ctl_name field no longer exists.
>>
>> kernel/binary_sysctl.c is used to provide backwards compatibility with
>> the old binary names.
>>
>> There might be a point for doing something in -stable or someone's
>> enterprise kernel if some messed up set of backports were merged.
>>
>> Eric
> Thanks for the quick response Eric!!
>
> Qing: It looks like this is not an issue in mainline.
>    If you want to get something fixed in SLES or RHEL, I suggest you log an
>    issue in the relevant bugzillas (though I just checked SLES11-SP2, and
>    it doesn't mention sysctl_check_dir at all).
>
> NeilBrown
