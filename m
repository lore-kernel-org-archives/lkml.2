Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0KYEK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:10:58 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49286 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab0KYEK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:10:57 -0500
MIME-Version: 1.0
In-Reply-To: <1290638773.14502.12.camel@concordia>
References: <4CE44B1B.9040709@freescale.com> <20101117215147.GA26792@suse.de>
 <4CE452CD.3050001@freescale.com> <20101117221903.GA4066@suse.de>
 <4CE45A4E.70308@freescale.com> <20101118022434.GA9833@suse.de>
 <4CE546C5.8060401@freescale.com> <20101118153912.GA1443@suse.de>
 <4CE54E40.9040503@freescale.com> <20101118112146.3275eb08@udp111988uds.am.freescale.net>
 <4CE5657D.8060105@freescale.com> <20101118121356.3491da72@udp111988uds.am.freescale.net>
 <1290594227.4446.12.camel@concordia> <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
 <1290638773.14502.12.camel@concordia>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 24 Nov 2010 21:10:36 -0700
X-Google-Sender-Auth: bRsm5BKqpdtnupKh4QWw2HAmOsE
Message-ID: <AANLkTikG3EfWRpY5DNGyjYgxJt9O+qkPr7onS60rRzw_@mail.gmail.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
To: michael@ellerman.id.au
Cc: Scott Wood <scottwood@freescale.com>, Timur Tabi <timur@freescale.com>,
        Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        devicetree-discuss@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 3:46 PM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On Wed, 2010-11-24 at 12:08 -0600, Scott Wood wrote:
>> On Wed, 24 Nov 2010 21:23:47 +1100
>> Michael Ellerman <michael@ellerman.id.au> wrote:
>
>> > > It would be nice if platform devices that are created from device tree
>> > > nodes included a link to the corresponding /proc/device-tree node in
>> > > their sysfs node.
>> >
>> > It's not a link, but the OF path is in devspec, so you can work it out
>> > fairly easily.
>>
>> Hmm, I see a "devspec" in PCI devices, but not in devtree-probed
>> platform devices.  of_bus_type_init isn't being called from anywhere
>> but the ibmebus code.  It looks like this was a casualty of merging
>> of_platform with platform (commit eca3930163ba8884060ce9d9ff5ef0d9b7c7b00f).
>
> Ah crud, yeah I was looking at an old kernel.
>
> That seems like a regression, but seemingly no one has complained so
> perhaps it doesn't matter in practice. It was certainly a nice feature
> though.

Hmmm, I missed that when merging.  Oops.

devspec is easy enough to add back since there isn't a conflict.  It
can even be made system-wide (not just platform bus) since any device
can have an of_node now.  However, the modalias and name attributes
are a lot harder since there are name conflicts.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
