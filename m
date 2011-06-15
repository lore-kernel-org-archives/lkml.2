Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab1FOBPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 21:15:36 -0400
Received: from mta31.charter.net ([216.33.127.82]:36548 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab1FOBPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 21:15:33 -0400
X-Authority-Analysis: v=1.1 cv=G6Q69DB3AUoJKS2BpLRaz8MQ2NORN7h5HRzrJMPOhRw=
 c=1 sm=1 a=p9YancsnzTcA:10 a=lE-93N_JSvIA:10 a=HnXbG3lm2xYA:10
 a=8nJEP1OIZ-IA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=UX0aQMcv2HLw9qoDOW8A:9
 a=U4TQN660WSfVbi0DGMMA:7 a=wPNLvfGTeEIA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DF807B4.8010807@gregd.org>
Date: Tue, 14 Jun 2011 20:15:32 -0500
From: Greg Dietsche <greg@farmergreg.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: if (ret) return ret; return ret; semantic
 patch
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk> <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu> <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk> <4DF67933.9080707@cuw.edu> <Pine.LNX.4.64.1106140746590.14970@ask.diku.dk> <4DF7D197.5070205@cuw.edu>
In-Reply-To: <4DF7D197.5070205@cuw.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/14/2011 04:24 PM, Greg Dietsche wrote:
> On 06/14/2011 12:50 AM, Julia Lawall wrote:
>> On Mon, 13 Jun 2011, Greg Dietsche wrote:
>>> just curious... i see you usually just write "return ret;" here when
>>> posting.
>>> I've assumed that's because it will 1) work and 2) is close enough.
>>>
>>> You'll notice I've been doing:
>>> -return ret;
>>> +return ret;
>>> because it seems to help coccinelle realize that it can get rid of
>>> extra line
>>> feeds - does this make sense - or should i just be doing a "return ret"?
>> I wondered why you were doing that :)
>>
>> Is the problem that the removed if is being replaced by a blank line? If
>> so, that is not intentional. I will look into it. If it doesn't happen
>> always, an example where it does happen could be helpful.
>>
>
> Some times it gets it right, so it's not always wrong. For example:
>
> diff -u -p a/arch/m68k/math-emu/fp_log.c b/arch/m68k/math-emu/fp_log.c
> --- a/arch/m68k/math-emu/fp_log.c 2011-06-13 14:06:37.943954469 -0500
> +++ b/arch/m68k/math-emu/fp_log.c 2011-06-14 16:07:22.394954040 -0500
> @@ -105,9 +105,6 @@ fp_fetoxm1(struct fp_ext *dest, struct f
>
> fp_monadic_check(dest, src);
>
> - if (IS_ZERO(dest))
> - return dest;
> -
> return dest;
> }
>
>
>
> Here's an example where it got it "wrong" - notice how the blank line is
> missing the - :
>
> diff -u -p a/arch/frv/mm/pgalloc.c b/arch/frv/mm/pgalloc.c
> --- a/arch/frv/mm/pgalloc.c 2011-06-13 14:06:37.855954391 -0500
> +++ b/arch/frv/mm/pgalloc.c 2011-06-14 16:07:16.714954008 -0500
> @@ -136,8 +136,6 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
> pgd_t *pgd;
>
> pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
> - if (!pgd)
> - return pgd;
>
> return pgd;
> }
>
>
> but when I do
> -return ret;
> +return ret;
>
> then both of the above examples are "correct"
>
>
> Greg
>
>
>> The disadvantage of removing something and then adding it back is that
>> then Coccinelle takes over the pretty printing of that thing. Since ret
>> is usually a variable, it doesn't matter, and since Coccinelle tries to
>> follow Linux spacing conventions it might not matter either. But eg
>> f(a,b,c,d) would become f(a, b, c, d).
>>
>> julia
>
>


here is another wierd one.. but this time it adds an extra blank line...:

diff -u -p a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c 
b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c 2011-06-13 
14:06:39.483954235 -0500
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c 2011-06-14 
19:20:38.915032203 -0500
@@ -3184,8 +3184,7 @@ wlc_user_txpwr_antport_to_rfport(phy_inf
  {
         s8 offset = 0;

-       if (!pi->user_txpwr_at_rfport)
-               return offset;
+
         return offset;
  }

