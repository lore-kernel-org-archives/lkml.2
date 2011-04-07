Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1DGJzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:55:08 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50123 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab1DGJzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vd2Pr9i9UWm9QjRhD/7wFrMxUPRhnf/euyU5vprfNhYvlm1GP9DRggsRSEelusejdK
         Re4MEeo2ie5WtiKp+YyHx3dpD342Ur45xIaJm8mEMjrxeLDm0WQYkXFVOw/Uj6Boii0c
         k6PhgvIsSd7l14HI+3gjNlN+gXInZ2Izy2biA=
MIME-Version: 1.0
In-Reply-To: <1302162886.10725.4.camel@maggie>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	<op.vti9ote53ri7v4@arend-laptop>
	<BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
	<BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
	<1302123428.20093.6.camel@maggie>
	<BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com>
	<1302124112.20093.11.camel@maggie>
	<BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com>
	<1302124737.27258.7.camel@dev.znau.edu.ua>
	<BANLkTi=4-LgrkjG96+Ar3SjMOsKh-dMuLg@mail.gmail.com>
	<1302134429.27258.32.camel@dev.znau.edu.ua>
	<BANLkTinfM0QLFwcKZXfWQ_jNYfBJg_et-Q@mail.gmail.com>
	<1302162886.10725.4.camel@maggie>
Date: Thu, 7 Apr 2011 11:55:03 +0200
Message-ID: <BANLkTim30i8kBkvsSvmWxQaNxWkfMjhOZA@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        Arend van Spriel <arend@broadcom.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 7 kwietnia 2011 09:54 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> On Thu, 2011-04-07 at 02:54 +0200, Rafał Miłecki wrote:
>> W dniu 7 kwietnia 2011 02:00 użytkownik George Kashperko
>> <george@znau.edu.ua> napisał:
>> > For PCI function description take a look at PCI specs or PCI
>> > configuration space description (e. g.
>> > http://en.wikipedia.org/wiki/PCI_configuration_space)
>> >
>> > Sorry for missleading short-ups, w11 - bcm80211 core, under two-head I
>> > mean ssb/axi with two functional cores on same interconnect (like w11
>> > +w11, not a lot of these exists I guess). Also there were some b43+b44
>> > on single PCI ssb host and those where implemented as ssb interconnect
>> > on multifunctional PCI host therefore providing separate access windows
>> > for each function.
>> >
>> > Might I mussunderstood something (its late night here at my place) when
>> > you where talking about using coreswitching involved for two drivers
>> > therefore I remembered about those functions. Seems now you were talking
>> > about chipcommon+b43 access sharing same window.
>> >
>> > As for core switching requirments for earlier SSB interconnects on PCI
>> > hosts where there were no direct chipcommon access, that one can be
>> > accomplished without spin_lock/mutex for b43 or b44 cores with proper
>> > bus design.
>> >
>> > AXI doesn't need spinlocks/mutexes as both chipcommon and pci bridge are
>> > available directly and b43 will be the only one requiring window access.
>>
>> Ahh, so while talking about 4 windows, I guess you counted fixes
>> windows as well. That would be right, matching my knowledge.
>>
>> When asking question about amount of cores we may want to use
>> simultaneously I didn't think about ChipCommon or PCIe. The real
>> problem would be to support for example two 802.11 cores and one
>> ethernet core at the same time. That gives us 3 cores while we have
>> only 2 sliding windows.
>
> Would that really be a problem? Think of it. This combination
> will only be available on embedded devices. But do we have windows
> on embedded devices? I guess not. If AXI is similar to SSB, the MMIO
> of all cores will always be mapped. So accesses can be done
> without switch or lock.
>
> I do really think that engineers at broadcom are clever enough
> to design a hardware that does not require expensive window sliding
> all the time while operating.

I also think so. When asking about amount of cores (non PCIe, non
ChipCommon) which has to work simultaneously. I'm not sure if we will
meet AI board with 2 cores (non PCIe, non ChipCommon) on PCIe host. I
don't think we will see more than 2 cores (non PCIe, non ChipCommon)
on PCIe host.

-- 
Rafał
