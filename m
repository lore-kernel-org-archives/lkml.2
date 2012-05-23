Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2EWHnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:43:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab2EWHnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:43:07 -0400
Message-ID: <4FBC9507.9070200@nod.at>
Date: Wed, 23 May 2012 09:43:03 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
CC: linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337608916-49771-1-git-send-email-richard@nod.at> <1337608916-49771-2-git-send-email-richard@nod.at> <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at> <20120522211809.53bd6444@halley> <2423212898cfc1c21343bff32e776dbd@radon2.swed.at> <20120523091856.4e9217a2@pixies.home.jungo.com>
In-Reply-To: <20120523091856.4e9217a2@pixies.home.jungo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2012 08:18, Shmulik Ladkani wrote:
>> It removes a PEB from the free rb-tree.
>> ubi->lookuptbl[pnum] does not matter at this time.
>
> For practical matters, you are correct.
> Design wise, it is bit inconsistent and confusing.
>
> On one hand, you claim above that 'ubi->lookuptbl' holds the WL entries
> known to WL subsystem - that is, lookuptbl is a data structure used and
> maintained by the WL subsystem.
> OTOH, when a PEB is removed from hands of WL (by a ubi_wl_get_fm_peb
> call), you keep its WL entry assigned in ubi->lookuptbl.
>
> I'll rethink this, see if there's a potential trouble here.

If I remove the PEB from ubi->lookuptbl I'll have to reread the EC 
header upon ubi_wl_put_fm_peb().
Otherwise it's EC value is lost.

>>> However 'ubi_wl_put_fm_peb' creates a 'ubi_wl_entry' if not found in
>>> the lookuptbl.
>> Currently fastmap "fixes" ubi->lookuptbl on demand. Is this a problem?
>
> I guess not.
>
> The only problem, as previously noted, is the failure to create a new
> 'ubi_wl_entry' when the PEB needs to be returned to WL subsystem.

I think I can return them to the lookuptbl while attaching.

Stay tuned, I'll release v7 today or tomorrow.

Thanks,
//richard
