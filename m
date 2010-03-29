Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0C2SWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:22:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57850 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0C2SWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:22:43 -0400
Message-ID: <4BB0EED2.4020406@zytor.com>
Date: Mon, 29 Mar 2010 11:17:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Giel van Schijndel <me@mortis.eu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hans de Goede <hdegoede@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>	<1269523063-30346-1-git-send-email-me@mortis.eu>	<20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>	<20100325180347.GA2761@salidar.me.mortis.eu>	<20100325181633.0313b8a5@lxorguk.ukuu.org.uk>	<20100329081834.GB27956@salidar.me.mortis.eu>	<20100329090713.1317942b@jbarnes-piketon>	<20100329173800.GA3583@salidar.me.mortis.eu>	<4BB0E73F.2080104@zytor.com> <20100329110633.702e3874@jbarnes-piketon>
In-Reply-To: <20100329110633.702e3874@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 11:06 AM, Jesse Barnes wrote:
>>
>> I have to question this approach a bit.
>>
>> I would much rather see this as a two-step process, where multiple
>> devices request the same region with a "sharable" flag, and then have a
>> mutex associated with the struct resource (perhaps we need an outer
>> container called "struct muxed_resource" or some such.)
>>
>> What I *really* object to with this patch is that it inherently assumes
>> that there is only one multiplexed resource in the entire system... but
>> of course nowhere enforces that.
> 
> Well that does keep it simple, and with just one user that's probably
> best.
> 
> But why not use the common bus driver method?  Muxing at the resource
> level only seems to solve part of the problem...  It doesn't guarantee
> for example that driver A does something to a shared region that breaks
> driver B; it just makes sure they don't access the same region at the
> same time.
> 

The common bus driver method is the obvious thing to do, but it would
presumably be greatly helped by librarization.

	-hpa
