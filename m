Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2EVULr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:11:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760372Ab2EVULq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:11:46 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 7bit
Date: Tue, 22 May 2012 22:11:43 +0200
From: Richard Weinberger <richard@nod.at>
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: <linux-mtd@lists.infradead.org>, <dedekind1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <Heinz.Egger@linutronix.de>,
        <tim.bird@am.sony.com>, <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
In-Reply-To: <20120522211809.53bd6444@halley>
References: <1337608916-49771-1-git-send-email-richard@nod.at>
 <1337608916-49771-2-git-send-email-richard@nod.at>
 <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at>
 <20120522211809.53bd6444@halley>
Message-ID: <b3d5919d0b35bb559b7dc115bc9e2720@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012 21:18:09 +0300, Shmulik Ladkani
<shmulik.ladkani@gmail.com> wrote:
> Hi Richard,
> 
> On Tue, 22 May 2012 18:55:10 +0200 Richard Weinberger <richard@nod.at> wrote:
>> >> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
>> >> index 2c5ed5c..ef5d7b7 100644
>> >> --- a/drivers/mtd/ubi/build.c
>> >> +++ b/drivers/mtd/ubi/build.c
>> >> @@ -144,6 +144,16 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
>> >>
>> >>   	ubi_do_get_device_info(ubi,&nt.di);
>> >>   	ubi_do_get_volume_info(ubi, vol,&nt.vi);
>> >> +
>> >> +	switch (ntype) {
>> >> +	case UBI_VOLUME_ADDED:
>> >> +	case UBI_VOLUME_REMOVED:
>> >> +	case UBI_VOLUME_RESIZED:
>> >> +	case UBI_VOLUME_RENAMED:
>> >> +		if (ubi_update_fastmap(ubi))
>> >> +			ubi_err("Unable to update fastmap!");
>> >
>> > In the error case, what are the consequences leaving the older on-flash
>> > fastmap? Shouldn't it be invalidated?
>>

After thinking a bit more about this case I think the best we can to is
switching to read-only mode if ubi_update_fastmap()
fails.

Thanks,
//richard
