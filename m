Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab0JZBec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:34:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33059 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab0JZBeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=n/yTv4TbezXFRDcs9UHTNWSwo44FzMDVrFVPKeuN9X9AsKXcd7dl8TdEBgjvUb1iTC
         dLdHykteK82XKmh9hkjp1VnQKwlj8GUyD/My9X5jDvOUUY1FC/s7gc0wOqUYwJNGAkav
         HKFxs/Q45hUIcsfObKmNGMzAPj369H9t8uXeY=
Subject: Re: [PATCH 04/29] memstick: core: rework state machines
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <381457.73980.qm@web37607.mail.mud.yahoo.com>
References: <381457.73980.qm@web37607.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:34:23 +0200
Message-ID: <1288056863.4024.66.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:01 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 04/29] memstick: core: rework state machines
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > Make state machines in memstick core
> > follow the
> > new style.
> > 
> 
> 1. This is an important functional patch. At present, "new style" exists
> only in your head. You should make an effort to justify it to everybody
> else by providing a rationale in patch description.
I already explained that.
Ok. I add that explanation to patch header.


> 
> 2. You are using an integer state variable (instead of function pointers
> which were self-describing by virtue of the referred function names).
> Please, define an enumerated type for this state variable, giving states
> human-readable, descriptive names. If you need to do state variable
> arithmetic, you can provide a couple of simple, descriptive macros to
> do so:
> 
> #define NEXT_STATE(s) (s + 1)
Do we have a corporate policy of no magic numbers?
Like this: http://thedailywtf.com/Articles/Avoiding-Magic-Constants.aspx


The issue here (I explained it already) is that I often use card-state
++; to get to next state;
Other the enforcing the policy the suggested #define it won't help.

card->state++ allows me for example to fallback through switch states
and go by default to next state by default without additional code.
If I bury state numbers with #defines or enums, the assumptions that
states appear in switch in ascending order won't be obvious anymore
and nether that adding 1 to state will bring me to next switch case.





> 
> or something along the line.
> 
> 3. Coding style.
Passed checkpatch.pl. Could you show me the lines affected?


Best regards,
	Maxim Levitsky


