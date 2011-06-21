Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab1FUTE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 15:04:56 -0400
Received: from rs35.luxsci.com ([66.216.127.90]:36335 "EHLO rs35.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310Ab1FUTEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 15:04:53 -0400
Message-ID: <4E00EB41.9080606@firmworks.com>
Date: Tue, 21 Jun 2011 09:04:33 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Shawn Guo <shawn.guo@freescale.com>, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org> <1308410354-21387-2-git-send-email-shawn.guo@linaro.org> <20110618161934.GH8195@ponder.secretlab.ca> <20110619073000.GA23171@S2100-06.ap.freescale.net> <20110621135558.GB9228@S2101-09.ap.freescale.net> <4E00E3D2.6050602@firmworks.com> <BANLkTiny9xDwiUww9Ys+jQZ0SHdQATABUA@mail.gmail.com>
In-Reply-To: <BANLkTiny9xDwiUww9Ys+jQZ0SHdQATABUA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2011 8:42 AM, Grant Likely wrote:
> On Tue, Jun 21, 2011 at 12:32 PM, Mitch Bradley<wmb@firmworks.com>  wrote:
>> I wonder if it makes sense to create a new device node "/linux-devices" to express a desired mapping from device nodes to /dev entries?  The properties could be the names of device special files and the values the corresponding node phandles.
>
> I've been trying /really/ hard to avoid doing something like that
> because a lot of the time the desired Linux dev name is a
> implementation detail, and a potentially unstable one at that.  If
> Linux requires certain devices to have certain names because that is
> how it hooks up clocks (which is the current situation on some
> platforms), then I'd rather have Linux encode a lookup of the
> preferred name, at least until the that particular implementation
> detail goes away.
>
> As for enumerating devices, I don't think this is a Linux-specific
> thing.  In this case it is entirely reasonable to want to say /this
> node/ is the second serial port, and /that node/ is the third, which
> is information needed regardless of the client OS.


This reminds me a little of the "slot-names" property defined by the PCI 
bus binding.  It was intended to correlate PCI device numbers with the 
corresponding externally-visible labeling of the slot, so that error 
messages could identify a slot using a name that had some meaning to a user.

The notion of "first" and "second" is, of course, rather difficult to 
define precisely.  What aspect of the device establishes the order?

The "slot-names" property was useful for systems from e.g. Sun, where 
one vendor controlled the whole system rollup.  It was almost useless 
for cases where the one vendor supplied the motherboard and others put 
it in various cases.

>
> g.
>
>
