Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2EMP3P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:29:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab2EMP3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:29:14 -0400
Message-ID: <4FAFD326.4020406@nod.at>
Date: Sun, 13 May 2012 17:28:38 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] UBI: Kill data type hint
References: <1336738443-112022-1-git-send-email-richard@nod.at>	 <1336738443-112022-2-git-send-email-richard@nod.at> <1336920094.2003.20.camel@koala>
In-Reply-To: <1336920094.2003.20.camel@koala>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.05.2012 16:41, schrieb Artem Bityutskiy:
> Hi Richard,
>
> On Fri, 2012-05-11 at 14:14 +0200, Richard Weinberger wrote:
>>   struct ubi_map_req {
>>          __s32 lnum;
>> -       __s8  dtype;
>> -       __s8  padding[3];
>> +       __s8  padding[4];
>>   } __packed;
>
>
> The "dtype" field is part of ABI, and merging it with padding is bad
> because padding holds "free" fields, which can be used in future. But
> "dtype" is not really free. I think it should stay here. You should put
> a comment explaining that it was used in the past for this and that, but
> now unused and ignored by UBI. Probably a date when we stopped using it
> would also be good.

Oh, it's ABI. Then I'll keep it and mark it as obsolete.

> May be it even deserves to be in a separate patches for this one and
> ubi_leb_change_req ?

Indeed.

Thanks,
//richard
