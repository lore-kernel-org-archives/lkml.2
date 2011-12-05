Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1LEUIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:08:45 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:32490 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab1LEUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:08:44 -0500
Message-ID: <4EDD24CA.2020906@tilera.com>
Date: Mon, 5 Dec 2011 15:08:42 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxin B. John" <maxin.john@gmail.com>, Tejun Heo <tj@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] lib/devres.c: allow specifying NO_IOPORT while using
 PCI
References: <cover.1322592494.git.mst@redhat.com> <1616727.0BYPKXtoA0@wuerfel> <4ED91D95.6040601@tilera.com> <201112051514.02360.arnd@arndb.de>
In-Reply-To: <201112051514.02360.arnd@arndb.de>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/2011 10:14 AM, Arnd Bergmann wrote:
> On Friday 02 December 2011, Chris Metcalf wrote:
>> The specific issue I saw was calls to pcim_iomap_{regions,table} from
>> drivers/ata/libata-sff.c and drivers/ata/sata_sil24.c; we use the
>> sata_sil24 in one of our platforms (TILEmpower).
> Hmm, so sata_sil24 does not actually use PIO, so we can probably find a
> way to make that work.

OK, that would be good.  I'm not familiar enough with the driver (or indeed
the devres stuff) to really take an effective swing at this myself, though.

> Why do you have to build libata-sff? Shouldn't
> that only be needed if you actually have an sff-type controller?

Yes, I think this is an accidental legacy of the original development work
for PCI root complex three years ago.  I disabled ATA_SFF and booted up a
number of our inhouse platforms, and all the devices appear to work fine
without it.  I've now turned it off in our standard configuration.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

