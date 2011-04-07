Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab1DGAyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:54:36 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49201 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab1DGAye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oqcyfSLhydSx+4+aOhDSWG1ggB9weQZVVH6oAFdoa8qe2MR++KtOXfV8rUw9dXkuwk
         gY1Rou+wAlmTrRH69JvoTcdacDwj12IPWsjZ8qLNbfPw0agji0yOY5Fo/jtTguYY1hp+
         f6Fs4pnzISfFmG2TViokQzpOUFPv9lborSPvw=
MIME-Version: 1.0
In-Reply-To: <1302134429.27258.32.camel@dev.znau.edu.ua>
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
Date: Thu, 7 Apr 2011 02:54:33 +0200
Message-ID: <BANLkTinfM0QLFwcKZXfWQ_jNYfBJg_et-Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 7 kwietnia 2011 02:00 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
> For PCI function description take a look at PCI specs or PCI
> configuration space description (e. g.
> http://en.wikipedia.org/wiki/PCI_configuration_space)
>
> Sorry for missleading short-ups, w11 - bcm80211 core, under two-head I
> mean ssb/axi with two functional cores on same interconnect (like w11
> +w11, not a lot of these exists I guess). Also there were some b43+b44
> on single PCI ssb host and those where implemented as ssb interconnect
> on multifunctional PCI host therefore providing separate access windows
> for each function.
>
> Might I mussunderstood something (its late night here at my place) when
> you where talking about using coreswitching involved for two drivers
> therefore I remembered about those functions. Seems now you were talking
> about chipcommon+b43 access sharing same window.
>
> As for core switching requirments for earlier SSB interconnects on PCI
> hosts where there were no direct chipcommon access, that one can be
> accomplished without spin_lock/mutex for b43 or b44 cores with proper
> bus design.
>
> AXI doesn't need spinlocks/mutexes as both chipcommon and pci bridge are
> available directly and b43 will be the only one requiring window access.

Ahh, so while talking about 4 windows, I guess you counted fixes
windows as well. That would be right, matching my knowledge.

When asking question about amount of cores we may want to use
simultaneously I didn't think about ChipCommon or PCIe. The real
problem would be to support for example two 802.11 cores and one
ethernet core at the same time. That gives us 3 cores while we have
only 2 sliding windows. But I would not care for that too much for
now.

For the rest (PCI function) I have to sleep before reading specs ;)

-- 
Rafał
