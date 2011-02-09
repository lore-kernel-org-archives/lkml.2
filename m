Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab1BITAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:00:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37211 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1BITAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CF2Mpo/G23EYW2/bCJpujs4vPjZzH9iG51bOBevdKwQqrjxCEW0dm6oq05AXzYuuSH
         xOhtl/kc4ZzztjcSnELYVWegQRB8X7TWYs1I7Zh1nIOAgusFhiw9mxsqbJNlCM5DiuJY
         9DqO5CWr85yvjoqfO/zfFfhybKXbd4/F4mXG0=
Message-ID: <4D52E441.2000805@am.sony.com>
Date: Wed, 09 Feb 2011 11:00:17 -0800
From: Frank Rowand <frank.rowand@gmail.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
References: <4D51D341.3040209@am.sony.com> <20110209114137.GA10163@opensource.wolfsonmicro.com> <201102091807.03094.rjw@sisk.pl> <4D52DD81.7050401@am.sony.com> <20110209184010.GB23747@opensource.wolfsonmicro.com>
In-Reply-To: <20110209184010.GB23747@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/11 10:40, Mark Brown wrote:
> On Wed, Feb 09, 2011 at 10:31:29AM -0800, Frank Rowand wrote:
> 
>> Raphael's patch will turn on CONFIG_PM in the correct circumstances, and
>> leave it off when not needed by other config options.  That means that
>> the size overhead will _not_ be an issue for me because CONFIG_PM
>> will not be enabled when not needed.
> 
> That's not the issue you seemed to be raising, though.  While PM is now
> turned on by PM_SLEEP that'll end up getting turned on by default due to
> the dependency on SUSPEND - you appeared to be raising the concern that
> this could happen and surprise users.

No, that is not my concern.  I was saying that Raphael's patches do
not trigger any concern from me.

My concern was that in your very first email that started this thread,
you wrote:

On 02/07/11 04:22, Mark Brown wrote:
> It is very rare to find a current system which is both sufficiently
> resource constrained to want to compile out power management support
> and sufficiently power insensitive to be able to tolerate doing so.
> Since having the configuration option requires non-zero effort to
> maintain, with ifdefery in most drivers, but it is used with vanishing
> rarity it is simpler to just remove the option.

and my understanding of this proposal was a goal to remove the ability
to have CONFIG_PM disabled, which results in increased memory usage
for some configurations.

-Frank
