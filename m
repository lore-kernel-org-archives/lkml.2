Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1DZS1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:27:38 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:47996 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751047Ab1DZS1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:27:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAOcNt01Ld/sX/2dsb2JhbAAMhEbXJpFMgSmDUH0ElSSHWQ
X-IronPort-AV: E=Sophos;i="4.64,270,1301889600"; 
   d="scan'208";a="111566870"
Message-ID: <4DB70E92.2020209@teksavvy.com>
Date: Tue, 26 Apr 2011 14:27:30 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com> <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com> <4D9CD275.9000002@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com> <4D9FACC9.7020200@teksavvy.com> <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com> <4DA45CA7.9040102@teksavvy.com> <4DA467FB.6020905@teksavvy.com> <20110423005610.GC1576@mtj.dyndns.org> <C1438B59050E1B4C9482FF3266AD6BA32C7755494A@gretna.indigovision.com> <20110425113036.GL17734@mtj.dyndns.org>
In-Reply-To: <20110425113036.GL17734@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-25 07:30 AM, Tejun Heo wrote:
> On Mon, Apr 25, 2011 at 12:07:04PM +0100, Bruce Stenning wrote:
>> Tejun, what does it mean to limit a sata link to UDMA/100? I thought that this
>> was only for ata devices, and sata devices have the choice of 1.5Gbps, 3Gbps,
>> or 6 Gbps. Is that a false assumption? Is it related to early sata devices that
>> were still somewhat based on parallel ata designs?
> 
> Yeap, devices behind SATA-PATA bridge were still affected by the
> transfer mode so libata tries to slow them down too along with link
> speed when limiting speed due to errors.  Shouldn't affect native SATA
> devices.


Yeah, what he said.  :)

First generation SATA devices were merely PATA transports
with a SATA-to-PATA converter chip onboard.  Some of those
require that we set the transfer modes.

Ditto for various more modern setups, where CF-cards, PATA drives,
and other weirdos are connected through a discrete SATA bridge device.

Cheers
