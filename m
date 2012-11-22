Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab2KVUHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:07:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53846 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab2KVUHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:07:08 -0500
Date: Thu, 22 Nov 2012 12:03:55 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        ??? <cw00.choi@samsung.com>, anish singh <anish198519851985@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>,
        "lockwood@android.com" <lockwood@android.com>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Re: Re: [PATCH] extcon : callback function to read cable property
Message-ID: <20121122200355.GA12397@lizard>
References: <32212704.282601353409543335.JavaMail.weblogic@epml17>
 <20ADAB092842284E95860F279283C564452531@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20ADAB092842284E95860F279283C564452531@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 01:00:52PM +0000, Tc, Jenny wrote:
[...]
> For this solution to work, the cable provider itself
> need to register with any of these subsystems - power_supply/regulator/charger manager
> IMHO a cable provider shouldn't register itself with any of the subsystem.
> 
>  For example it cannot register with power_supply subsystem
> since it's not a power_supply. It's just source for a power_supply.
> We register either charger/battery with power supply. I couldn't find a way
> to register the cable with power supply subsystem.

Yes, I guess that doesn't make much sense.

> Anton,
> Do you have any suggestion here?
> 
> I think the same case with regulator framework also. A cable doesn¡¯t belong
> to a regulator framework. A cable doesn¡¯t expose any control attribute (current control/voltage
> control). It just have  properties (eg current) controlled by external agents (Host machine/wall charger)
> 
> And charger manager is a consumer and not a provider. It cannot decide the charger cable capabilities.
> 
> I  have a modified version of the above patch which uses properties directly. 
> https://gitorious.org/linux-charging-framework/linux-charging-framework/commit/ff358373dcb32027ebe1a267fc8b8999a3bd37e4

(Please, always inline the patches.)

I spent some time trying to understand what exactly you're trying to
accomplish and I failed, and that's why:

1. I see only some small snippets of the code, sometimes by means of URLs
   and references to another patches, which is hard to follow when you
   have like tens of emails in the thread;
2. I believe I still didn't see a user of this callback.

So, basically you're trying to force me to read your mind and guess your
ideas, but as it appears, I'm not good at it. :)

So, please do the following:

- Prepare a complete, but minimal workable solution, a patchset that shows
  how exactly you use the new features that you introduce;

- The series must be an all-in-1 patchset, so people won't need to go back
  and forth trying to understand how things depend on each other;

- Briefly describe how things work, a typical use-case and how drivers
  interact with each other. E.g. which driver registers extcon_device,
  which driver reads mA field, which driver sets mA field (and based on
  what information), which driver listens for the extcon events, which
  driver produces the extcon events, etc. No need for lengthy explanations
  about why you made the decisions, just a brief explanation of how things
  currently work and interact.

Thanks,
Anton.
