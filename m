Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2EXIYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:24:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab2EXIYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:24:36 -0400
Message-ID: <4FBDF03F.8050006@nod.at>
Date: Thu, 24 May 2012 10:24:31 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Subject: Re: [PATCH] [RFC] UBI: Implement Fastmap support
References: <1337608916-49771-1-git-send-email-richard@nod.at>  <1337608916-49771-2-git-send-email-richard@nod.at>  <20120522180119.2c2a10a8@pixies.home.jungo.com> <4FBBC4EE.4040802@nod.at> <1337847720.15137.85.camel@sauron.fi.intel.com>
In-Reply-To: <1337847720.15137.85.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.2012 10:22, Artem Bityutskiy wrote:
> On Tue, 2012-05-22 at 18:55 +0200, Richard Weinberger wrote:
>>>> +     * has never seen any PEB used by the original fastmap.
>>>> +     */
>>>> +    if (!e) {
>>>> +            ubi_assert(ubi->old_fm);
>>>> +            e = kmem_cache_alloc(ubi_wl_entry_slab, GFP_ATOMIC);
>>>
>>> Must it be GFP_ATOMIC?
>>
>> Yes. This function is called under a spinlock.
>
> I did not look close, but this sounds bad.
>
> You need to have a much better justification than "I allocate it under a
> spinlock". You need to tell "... because there is no way or very
> difficult to pre-allocate it while I do not have the spinlock held,
> because ... (explanation)".
>

True, in v7 I've reworked ubi_wl_put_fm_peb(). Now it does no longer 
need GFP_ATOMIC.

Thanks,
//richard
