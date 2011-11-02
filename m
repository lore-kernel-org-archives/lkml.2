Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab1KBQZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:25:14 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:15272
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932495Ab1KBQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:25:10 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bhz2fh668h839h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EB16EC3.8020209@am.sony.com>
Date: Wed, 2 Nov 2011 09:24:35 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: David Decotigny <david.decotigny@google.com>,
        Kroah-Hartman <gregkh@suse.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "Richard@mail2.fw-bc.sony.com" <Richard@mail2.fw-bc.sony.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Dmitry Torokhov <dtor@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Schmidt <mschmidt@redhat.com>,
        "David@mail2.fw-bc.sony.com" <David@mail2.fw-bc.sony.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Greg@mail2.fw-bc.sony.com" <Greg@mail2.fw-bc.sony.com>,
        Satoru Moriya <satoru.moriya@hds.com>, Sievers <kay.sievers@vrfy.org>,
        Decotigny <decot@google.com>,
        "Kay@mail2.fw-bc.sony.com" <Kay@mail2.fw-bc.sony.com>,
        Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [Kgdb-bugreport] [PATCH v2 3/3] param: make	/sys/module/*/paramaters
 optional
References: <cover.1320191327.git.david.decotigny@google.com>	<4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com> <4EB145FB.70906@windriver.com>
In-Reply-To: <4EB145FB.70906@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2011 6:30 AM, Jason Wessel wrote:
> On 11/01/2011 06:50 PM, David Decotigny wrote:
>> From: David Decotigny<decot@google.com>
>>
>> With this patch, we allow systems that don't want to pay the price for
>> /sys/module/*/paramaters to be compiled without that feature. This
>> abiltity can in turn encourage module developers to expose more of
>> their parameters with fewer hesitations (eg. memory concerns, etc.);
>> this is desirable to help debugging/auditing of live (larger) systems.
>>
>> The new knob to control that is CONFIG_SYSFS_MODULE_PARAM available in
>> Kconfig in expert mode: File systems / Pseudo filesystems / sysfs file
>> system support / Module parameters in sysfs. It is enabled by default,
>> keeping /sys/module/*/paramaters/ available as before.
>>
>> As an illustration, on my copy I see 1658 module_param() macros with
>> perm == 0: most of these could be exposed to user (perm != 0).
> Speaking as an embedded developer who works on very small systems that you can still debug, I am really curious what you actually save here?
>
> For dynamic kgdb/kdb this patch is a death sentence.  It would make us have to resurrect the procfs entries for the control point.  There is no possible way to dynamically turn kgdb on and off at all if you remove the /sys/module/kgdboc/parameters/kgdboc entry, and this is certainly something where the typical use case is dynamic enablement.
I would also like to see the size numbers.  However, to address
Jason's concern, I think it's safe to assume that when someone is
getting this aggressive with system size, they'll start leaving debug
features on the floor (printk, kdb, etc.).  What would be appropriate,
IMHO, would be to add a config dependency for kgdb/kdb and
NOT resurrect /proc items.  There's work in progress in linux-tiny
to tackle /proc configurability, and adding back /proc interfaces
is likely to just have the issue resurface there.
  -- Tim


