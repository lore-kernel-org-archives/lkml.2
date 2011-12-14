Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1LNUfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:35:12 -0500
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:58138 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab1LNUfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:35:08 -0500
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Liam Girdwood <lrg@ti.com>, Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:34:37 -0600
Subject: Re: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Topic: [REPOST RFC PATCH 0/3] New "gpio-poweroff" driver to turn off
 platform devices with GPIOs
Thread-Index: Acy6n80PtBv2HOOTTFSJvlaDj/xy1g==
Message-ID: <E30C4693-0D31-4A9A-9E9D-0FC03C5F6B8A@boeing.com>
References: <1323800614-12642-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <4EE7A31E.7080301@gmail.com>
 <895CF182-4BF7-4DF5-A467-944EC008DBC3@boeing.com>
 <20111214120240.GC25088@sirena.org.uk>
In-Reply-To: <20111214120240.GC25088@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-10.0.0.1412-6.800.1017-18582.001
x-tm-as-result: No--46.430100-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 2011, at 07:02, Mark Brown wrote:
> On Tue, Dec 13, 2011 at 02:44:48PM -0600, Moffett, Kyle D wrote:
>> I looked at it a bit when I was generalizing my code, but it seemed
>> dramatically more complicated than I needed, and I couldn't see any
>> reasonable way to hook it from the machine_poweroff() code.
> 
> Some ST platform had to do odd stuff with regulators to power off, it
> made a platform device representing the odd poweroff code.

This is actually what I did originally, albeit with GPIOs.

In our case we have a chassis with 6 computers in it, and one of the
computers has 3 GPIOs which are wired to the "off" signal for each domain
(one domain per pair of computers).

Due to isolation requirements, that computer can't turn the domains back
on from software, so really all we need to be able to do is trigger each
GPIO in sequence as part of the poweroff.

So basically the "gpio-poweroff" driver was just a slightly-more-generic
way of doing what I was doing before, by looking up the GPIOs in the
device-tree.


>> There's also the fact that I was looking for a pure-device-tree type
>> of driver and the regulator framework does not seem to support the
>> standard OF-platform probe system.
> 
> The regulator API in -next has DT bindings.

Based on the description of our hardware, is there a good way that I
can wire up gpio-regulator driver to our hardware with just the device
tree (and maybe one small board-specific function) to make it shut down
each domain in sequence at poweroff time? Otherwise I will just go back
to my custom board-specific function for GPIO-twiddling.

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/


