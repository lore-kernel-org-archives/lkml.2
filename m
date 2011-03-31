Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab1CaTPK (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 31 Mar 2011 15:15:10 -0400
Received: from usul.saidi.cx ([204.11.33.34]:56764 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759164Ab1CaTPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:15:07 -0400
X-Greylist: delayed 1624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 15:15:07 EDT
To: Chris Ball <cjb@laptop.org>
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
X-PHP-Originating-Script: 501:func.inc
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Mar 2011 11:47:46 -0700
From: Philip Langdale <philipl@overt.org>
Cc: Manoj <manoj.iyer@canonical.com>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <m3vcyzuols.fsf@pullcord.laptop.org>
References: <4D93AD5C.1070308@canonical.com>
 <m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>
 <m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>
 <m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com>
 <m3oc4rz5kp.fsf@pullcord.laptop.org> <4D94A510.4040509@canonical.com>
 <m3fwq3z1yu.fsf@pullcord.laptop.org> <4D94B552.8020108@canonical.com>
 <m3zkoburoz.fsf@pullcord.laptop.org> <4D94C0E5.6070801@canonical.com>
 <m3vcyzuols.fsf@pullcord.laptop.org>
Message-ID: <d21c920c680eac13afdf6b214627325e@mail.overt.org>
User-Agent: RoundCube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Thu, 31 Mar 2011 14:33:19 -0400, Chris Ball <cjb@laptop.org> wrote:
> Hi Manoj,
>
> On Thu, Mar 31 2011, Manoj wrote:
>> Card did not mount. New dmesg is attached.
>
> Okay.  There's nothing in the log about Ricoh, which probably means 
> that
> it bailed out early in the function.  You could add a printk to the 
> top
> of ricoh_mmc_fixup_rl5c476() if you want to be really sure that the 
> code
> there is getting a chance to run.
>
> I think the likely conclusion is that:
>
> (a) The Ricoh controller has a proprietary MMC function that is 
> stealing
>     MMC cards away from the SDHCI controller even though the SDHCI 
> could
>     read them if it had a chance to.
>
> (b) We don't know how to turn the MMC controller off, because our old
>     method for doing so isn't working on this new 0xe823 model.
>
> I'm adding a few people who've touched this code to CC: in case they
> have any ideas on working out how to disable the MMC function.  If 
> you
> have contact with Ricoh directly or through a vendor, please ask them
> for the PCI configuration writes needed to disable the MMC function 
> on
> this model so that you can read MMC cards with the SD interface 
> instead.

 For what it's worth, I previously investigated a Dell e6400 with an 
 0x822
 and an 0x823 and even without the MMC function disabled, the SD 
 function
 would get the SD card. The machine I currently have access to just has
 the 0x822 function so I doubt it can be used to prove anything.

 I was under the impression they'd changed the priority of the 
 controllers
 (and probably requiring the MMC driver to set a flag to make it steal
 cards)

 --phil
