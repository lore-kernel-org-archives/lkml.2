Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1ELRWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:22:43 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52423 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108Ab1ELRWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110512145633.69302dd4.sfr@canb.auug.org.au>
References: <20110512141019.72ccb7a7.sfr@canb.auug.org.au> <BANLkTik+=yh3eq6Snp9SfC0xn--Deccefw@mail.gmail.com>
 <20110512145633.69302dd4.sfr@canb.auug.org.au>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 12 May 2011 10:22:20 -0700
Message-ID: <BANLkTiknar_vMtmr659yNCVFz-V0W9XvOQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (wireless
 tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 9:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Wed, 11 May 2011 21:37:16 -0700 Javier Cardona <javier@cozybit.com> wrote:
>>
>> Hi Stephen,
>>
>> On Wed, May 11, 2011 at 9:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> > Hi John,
>> >
>> > After merging the final tree, today's linux-next build (i386 defconfig)
>> > failed like this:
>> >
>> > net/mac80211/cfg.c: In function 'sta_apply_parameters':
>> > net/mac80211/cfg.c:746: error: 'struct sta_info' has no member named 'plink_state'
>>
>> Sorry, I just saw this.  My apologies.  The fixup is valid but I'm
>> trying to understand why it is needed.
>> ieee80211_vif_is_mesh(&sdata->vif) compiles to 'false' when
>> CONFIG_MAC80211_MESH is not defined... wouldn't the compiler remove
>> that dead code? (Obviously it did not...)
>
> The compiler will elide that code but only after compiling it, so the
> code still has to be correct.

Thanks for the explanation.

>> Anyway, given that this is necessary, it's probably cleaner to extend
>> the #ifdef block to the entire body of the outer if as follows:
>
> I think you have the #ifdef one line too low.

My intent was to have the #endif one line above, but either way works.
 That's the problem of preparing patches on pajamas.
How can I help at this point?  Would resubmitting the patch help or
just add noise?

Cheers,

Javier

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
