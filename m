Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab2EXI04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:26:56 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2EXI0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:26:53 -0400
Message-ID: <4FBDF0CB.4040501@nod.at>
Date: Thu, 24 May 2012 10:26:51 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337608916-49771-1-git-send-email-richard@nod.at>  <1337608916-49771-2-git-send-email-richard@nod.at>  <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at>  <20120522211809.53bd6444@halley>  <b3d5919d0b35bb559b7dc115bc9e2720@radon2.swed.at> <1337847592.15137.83.camel@sauron.fi.intel.com>
In-Reply-To: <1337847592.15137.83.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.2012 10:19, Artem Bityutskiy wrote:
>> After thinking a bit more about this case I think the best we can to
>> is
>> switching to read-only mode if ubi_update_fastmap()
>> fails.
>>
> Unless it fails because of -EIO, which means the PEB may become bad and
> you need to pick a different one and schedule the faulty one for
> torturing and marking as bad.

Wouldn't make more sense if ubi_update_fastmap() handles the -EIO case 
internally?

Currently (as of v7) both callers ubi_volume_notify() and 
ubi_wl_get_peb() check the return value of ubi_update_fastmap()
and set UBI into read-only mode if ubi_update_fastmap() fails.

Thanks,
//richard
