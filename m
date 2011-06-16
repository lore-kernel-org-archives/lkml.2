Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab1FPN2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:28:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53886 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1FPN2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:28:42 -0400
Message-ID: <4DFA0507.3090609@linux.vnet.ibm.com>
Date: Thu, 16 Jun 2011 08:28:39 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Nishanth Aravamudan <nacc@us.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        wayneb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, mbizon@freebox.fr, jgarzik@pobox.com
Subject: Re: libata/ipr/powerpc: regression between 2.6.39-rc4 and 2.6.39-rc5
References: <20110615191747.GA6324@us.ibm.com> <4DF90FCA.1040706@linux.vnet.ibm.com>	<20110615233417.GB6324@us.ibm.com> <20110616075114.GH8141@htj.dyndns.org>
In-Reply-To: <20110616075114.GH8141@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 02:51 AM, Tejun Heo wrote:
> On Wed, Jun 15, 2011 at 04:34:17PM -0700, Nishanth Aravamudan wrote:
>>> That looks like the right thing to do. For ipr's usage of
>>> libata, we don't have the concept of a port frozen state, so this flag
>>> should really never get set. The alternate way to fix this would be to
>>> only set ATA_PFLAG_FROZEN in ata_port_alloc if ap->ops->error_handler
>>> is not NULL.
>>
>> It seemed like ipr is as you say, but I wasn't sure if it was
>> appropriate to make the change above in the common libata-scis code or
>> not. I don't want to break some other device on accident.
>>
>> Also, I tried your suggestion, but I don't think that can happen in
>> ata_port_alloc? ata_port_alloc is allocated ap itself, and it seems like
>> ap->ops typically gets set only after ata_port_alloc returns?
> 
> Maybe we can test error_handler in ata_sas_port_start()?

Good point. Since libsas is converted to the new eh now, we would need to have
this test.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


