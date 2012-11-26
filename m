Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2KZTZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:25:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:53371 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab2KZTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:25:10 -0500
Message-ID: <50B3C211.6000600@wwwdotorg.org>
Date: Mon, 26 Nov 2012 12:25:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Jonas ABERG <jonas.aberg@stericsson.com>
Subject: Re: [PATCH V3 10/11] ARM: remove struct sys_timer suspend and resume
 fields
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org> <1353349867-28494-11-git-send-email-swarren@wwwdotorg.org> <CACRpkdb-cmwTH_7EJO02m2+CCZrJ2ycgtGpf8stoiFKSm8jqww@mail.gmail.com>
In-Reply-To: <CACRpkdb-cmwTH_7EJO02m2+CCZrJ2ycgtGpf8stoiFKSm8jqww@mail.gmail.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2012 01:28 AM, Linus Walleij wrote:
> Oh and there was this comment/TODO:
> 
> On Mon, Nov 19, 2012 at 7:31 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> @@ -17,15 +17,6 @@
>>   *   Initialise the kernels jiffy timer source, claim interrupt
>>   *   using setup_irq.  This is called early on during initialisation
>>   *   while interrupts are still disabled on the local CPU.
>> - * - suspend
>> - *   Suspend the kernel jiffy timer source, if necessary.  This
>> - *   is called with interrupts disabled, after all normal devices
>> - *   have been suspended.  If no action is required, set this to
>> - *   NULL.
>> - * - resume
>> - *   Resume the kernel jiffy timer source, if necessary.  This
>> - *   is called with interrupts disabled before any normal devices
>> - *   are resumed.  If no action is required, set this to NULL.
>>   * - offset
>>   *   Return the timer offset in microseconds since the last timer
>>   *   interrupt.  Note: this must take account of any unprocessed
>> @@ -33,8 +24,6 @@
>>   */
>>  struct sys_timer {
>>         void                    (*init)(void);
>> -       void                    (*suspend)(void);
>> -       void                    (*resume)(void);
>>  };
> 
> So from the above it is quite clear that the sys_timer is breaking
> the suspend_noirq/resume_noirq naming convention from
> runtime PM as IRQs are disabled on these paths.
> 
> The same goes for struct clock_event_device ...
> 
> So while this looks just as bad after as before the patch,
> we should take a mental notice to rename the .suspend
> and .resume hooks in the clock_event_device to
> .suspend_noirq and .resume_noirq at some point.
> 
> I was thinking that if your patch set is introducing a
> plethora of new users of these hooks we should maybe
> stick a patch at the beginning of the series renaming the
> hooks to *_noirq, but if it's a major obstacle it can surely wait.

I think I'd prefer to keep that rename separate and do it later; while
this series does introduce a few new users of the type, there are many
more pre-existing users. Renaming all the users would end up making this
series potentially conflict with addition of new users in tip.git or
elsewhere, whereas any possible current conflicts from this series
should be resolvable in arm-soc pretty easily I hope, so I'd rather
create a separate series that does the rename, and probably apply it to
tip.git, probably for 3.10?
