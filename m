Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2HUUiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 16:38:15 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:9386
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757294Ab2HUUiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 16:38:08 -0400
X-Forefront-Antispam-Report: CIP:157.56.245.5;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0710HT001.namprd07.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839hd25he5bhf0ah107ah1155h)
Message-ID: <5033F1AA.4080308@caviumnetworks.com>
Date: Tue, 21 Aug 2012 13:38:02 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: David Daney <ddaney.cavm@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        <linux-doc@vger.kernel.org>, David Daney <david.daney@cavium.com>
Subject: Re: [2/2] spi: Add SPI master controller for OCTEON SOCs.
References: <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com> <20120821194936.GA7145@roeck-us.net>
In-Reply-To: <20120821194936.GA7145@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 12:49 PM, Guenter Roeck wrote:
> On Fri, May 11, 2012 at 08:34:46PM -0000, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> Add the driver, link it into the kbuild system and provide device tree
>> binding documentation.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>>
> [ ... ]
>
>> +
>> +static int __devexit octeon_spi_remove(struct platform_device *pdev)
>> +{
>> +	struct octeon_spi *p = platform_get_drvdata(pdev);
>> +	struct spi_master *master = p->my_master;
>> +
>> +	spi_unregister_master(master);
>> +
>
> I know it is a bit late, but ...

In this case, just in time.  I am now finally getting back to fixing the 
issues with this driver, and looking to merging it in the near future.

David Daney

>
> The call to spi_unregister_master() frees the memory associated with master,
> ie 'p', and the spi_master_put() below without matching spi_master_get() is
> unnecessary/wrong. One possible fix would be to use
>
> 	struct spi_master *master = spi_master_get(p->my_master);
>
> above. That protects master and p while it is still being used, and makes use
> of the call to spi_master_put() below. Another option might be to move
> cvmx_write_csr() ahead of the call to spi_unregister_master() and drop the
> call to spi_master_put().
>
> Guenter
>
>> +	/* Clear the CSENA* and put everything in a known state. */
>> +	cvmx_write_csr(p->register_base + OCTEON_SPI_CFG, 0);
>> +	spi_master_put(master);
>> +	return 0;
>> +}
>> +
>


