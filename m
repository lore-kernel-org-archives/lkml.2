Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab0KWJSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:18:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51010 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab0KWJSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:18:11 -0500
Date: Tue, 23 Nov 2010 10:17:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
        Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101123091756.GA22530@elte.hu>
References: <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
 <20101118082454.GC15928@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
 <4CEAA151.7050404@arndnet.de>
 <20101123063200.GA23907@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
 <20101122233654.117eef93.akpm@linux-foundation.org>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
 <20101123075742.GA28714@elte.hu>
 <20101123000232.e51b99b7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101123000232.e51b99b7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Nov 2010 08:57:42 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Berg, Johannes <johannes.berg@intel.com> wrote:
> > 
> > > > > Hmm. For some reason I thought this patch had made it into -mm,
> > > > > but I never double-checked and then went travelling ...
> > > > >
> > > > > http://lkml.org/lkml/2010/10/26/79
> > > > 
> > > > oops, I filed it in the wrong drawer, under "non-urgent".  It then got
> > > > buried in new paperwork.  But not lost!
> > > > 
> > > > Gee it's big.  Could you please double-check that it is still complete?
> > > 
> > > Will do. I suspect it should, unless you took new LED drivers? But then
> > > again you will now probably want a patch against -rc, not -mm?
> > 
> > It applied with a fuzz here so something changed in that file since you made the 
> > patch. I did a quick review of drivers/leds/Kconfig and your patch seems complete to 
> > me.
> 
> It looks complete to me as well.  It already fixes LEDS_NETXBIG.

It fails to build on x86 64-bit allmodconfig:

drivers/leds/led-triggers.c:39:20: error: ‘TRIG_NAME_MAX’ undeclared (first use in this function)
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:56:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:57:33: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:58:24: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:60:22: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:80:21: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:82:15: error: ‘struct led_classdev’ has no member named ‘trigger’
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:87:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:88:15: error: ‘struct led_classdev’ has no member named ‘trigger’
drivers/leds/led-triggers.c:88:44: error: ‘struct led_classdev’ has no member named ‘trigger’
drivers/leds/led-triggers.c:89:12: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:90:41: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:92:39: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:94:19: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:103:6: error: expected identifier or ‘(’ before ‘do’
drivers/leds/led-triggers.c:103:6: error: expected identifier or ‘(’ before ‘while’
drivers/leds/led-triggers.c:127:19: error: ‘led_trigger_set’ undeclared here (not in a function)
drivers/leds/led-triggers.c:129:6: error: expected identifier or ‘(’ before ‘do’
drivers/leds/led-triggers.c:129:6: error: expected identifier or ‘(’ before ‘while’
drivers/leds/led-triggers.c:135:19: error: ‘led_trigger_remove’ undeclared here (not in a function)
drivers/leds/led-triggers.c:137:6: error: expected identifier or ‘(’ before ‘do’
drivers/leds/led-triggers.c:137:6: error: expected identifier or ‘(’ before ‘while’
drivers/leds/led-triggers.c:153:19: error: ‘led_trigger_set_default’ undeclared here (not in a function)
drivers/leds/led-triggers.c:162:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:163:25: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:167:2: error: request for member ‘next_trig’ in something not a structure or union
drivers/leds/led-triggers.c:168:19: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:168:34: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:174:24: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:180:23: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:181:16: error: ‘struct led_classdev’ has no member named ‘trigger’
drivers/leds/led-triggers.c:182:50: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:184:21: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:198:19: error: dereferencing pointer to incomplete type
drivers/leds/led-triggers.c:204:23: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:205:15: error: ‘struct led_classdev’ has no member named ‘trigger’
drivers/leds/led-triggers.c:207:21: error: ‘struct led_classdev’ has no member named ‘trigger_lock’
drivers/leds/led-triggers.c:215:6: error: expected identifier or ‘(’ before ‘do’
drivers/leds/led-triggers.c:215:6: error: expected identifier or ‘(’ before ‘while’
drivers/leds/led-triggers.c:232:19: error: ‘led_trigger_event’ undeclared here (not in a function)
drivers/leds/led-triggers.c:234:6: error: expected identifier or ‘(’ before ‘do’
drivers/leds/led-triggers.c:234:6: error: expected identifier or ‘(’ before ‘while’
drivers/leds/led-triggers.c:253:19: error: ‘led_trigger_register_simple’ undeclared here (not in a function)
drivers/leds/led-triggers.c:255:6: error: expected identifier or ‘(’ before ‘do’
drivers/leds/led-triggers.c:255:6: error: expected identifier or ‘(’ before ‘while’
drivers/leds/led-triggers.c:261:19: error: ‘led_trigger_unregister_simple’ undeclared here (not in a function)
net/rfkill/core.c:67:21: error: field ‘led_trigger’ has incomplete type
net/rfkill/core.c:147:11: error: ‘struct led_classdev’ has no member named ‘trigger’
net/rfkill/core.c:171:2: error: implicit declaration of function ‘led_trigger_register’
net/rfkill/core.c:176:2: error: implicit declaration of function ‘led_trigger_unregister’
net/mac80211/led.c:59:33: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
net/mac80211/led.c:63:16: error: dereferencing pointer to incomplete type
net/mac80211/led.c:64:3: error: implicit declaration of function ‘led_trigger_register’
net/mac80211/led.c:70:33: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
net/mac80211/led.c:74:16: error: dereferencing pointer to incomplete type
net/mac80211/led.c:81:36: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
net/mac80211/led.c:85:19: error: dereferencing pointer to incomplete type
net/mac80211/led.c:92:36: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
net/mac80211/led.c:96:19: error: dereferencing pointer to incomplete type
net/mac80211/led.c:107:3: error: implicit declaration of function ‘led_trigger_unregister’
net/netfilter/xt_LED.c:47:21: error: field ‘netfilter_led_trigger’ has incomplete type
net/netfilter/xt_LED.c:132:2: error: implicit declaration of function ‘led_trigger_register’
net/netfilter/xt_LED.c:183:2: error: implicit declaration of function ‘led_trigger_unregister’

Thanks,

	Ingo

