Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1FGPsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 11:48:00 -0400
Received: from mta11.charter.net ([216.33.127.80]:33991 "EHLO
	mta11.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1FGPr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 11:47:59 -0400
X-Authority-Analysis: v=1.1 cv=1b2X7W/SifksZeClH/haT1SUt4udqxFGF00pZw2/jJk=
 c=1 sm=1 a=p9YancsnzTcA:10 a=N2sXiA72-zoA:10 a=8nJEP1OIZ-IA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:17 a=rrh4essHKPRb6ZcEuFkA:9 a=wPNLvfGTeEIA:10
 a=xzrYXqw+0zwiO4gHSXHcAg==:117
Message-ID: <4DEE482D.7020505@cuw.edu>
Date: Tue, 07 Jun 2011 10:47:57 -0500
From: Greg Dietsche <gregory.dietsche@cuw.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic patch
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu> <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On 06/05/2011 11:55 PM, Julia Lawall wrote:
> Thanks.  I tried this too, but I wasn't sure about the results.  The
> question is why stop here.
very interesting! Honestly I hadn't thought much further than what you 
see in my semantic patch. I'd noticed piece of code in the iwlegacy 
driver and wondered what'd happen if I taught myself a little bit about 
cocci :)
>    For example, there are IS_ERR calls that one
> could consider as well.  Or ret<  0.  Or why not just:
>
> @@
> expression ret;
> @@
>
> - if (...) return ret;
>    return ret;
>
> Although there might be function calls that one doesn't want to touch, so:
>
> @@
> identifier f != IS_ERR;
> expression ret;
> statement S;
> @@
>
> (
> if (<+...f(...)...+>) S
> |
> - if (...) return ret;
>    return ret;
> )
>
> julia
>
>
>    
There seem to be many variations on the theme to consider... though 
hopefully the compiler optimizes most of these out... For example, in 
sound/soc/codecs/wm8940.c, Jonathan Cameron pointed some code out to me 
that looks like this:

         if (ret)
                 goto error_ret;

error_ret:
         return ret;




As an aside, I added a feature to the script for myself so that I can 
for example write 'make coccicheck M=drivers/net/wireless/' for example 
to focus in on that directory and just run the checks there... I can 
submit a patch for this... though I was wondering if there is already a 
way to do this and I just missed it. The thought was to make it work the 
same way you'd build a module.


Greg

