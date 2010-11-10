Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab0KJOfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:35:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:39605 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab0KJOfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:35:09 -0500
Message-ID: <4CDAAD82.9090007@ti.com>
Date: Wed, 10 Nov 2010 09:34:42 -0500
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: cyril@ti.com
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <david-b@pacbell.net>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>
Subject: Re: [PATCH v4 08/12] gpio: add ti-ssp gpio driver
References: <20101110044530.GB4110@angua.secretlab.ca> <79124.87409.qm@web180307.mail.gq1.yahoo.com> <20101110062310.GB7431@angua.secretlab.ca>
In-Reply-To: <20101110062310.GB7431@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 01:23 AM, Grant Likely wrote:
> On Tue, Nov 09, 2010 at 10:16:22PM -0800, David Brownell wrote:
>>
>>> I thought the point of this device was that a single [SSP] device
>>> hosted a
>>> pair of multi-function serial interfaces, with each
>>> implementing a
>>> separate function.
>>
>> function chosen based on what the board needs.
>> Codec interface, SPI, GPIO, etc.
>>
>>   If so, then it makes sense for the
>>> base driver to
>>> register child devices of the appropriate kinds.
>>
>> I'd normally say board setup registers them; a
>> "core"driver can't know what children would be needed.
>>
>> But the point I was making was about code factoring
>> not driver setup.  When  the functions don't have
>> much commonality, they might as well just write to
>> the relevant registers instead of expecting to have
>> a non-register programming interface (of dubious
>> generality of a "core" driver, but much complexity).
>>
>> Easier just to have children use registers directly,
>> in several similar cases.  Less overhead, too.
> 
> I guess it depends on how much overlap/interlock there is between the
> multiple channels.  If there is shared context, then that is a
> stronger argument for a shared api.  Cyril, what say you?
> 

The channels (or ports) in this case are not very well separated out.
The registers for these ports are interleaved, and in some cases
different bits of the same register are meant for different ports.

Second, with the exception of GPIO (which essentially bit bangs), all
other functions would follow the same flow, i.e. set stuff up (mode,
iosel), load up a sequence, kick off execution, and wait for completion.
 I thought it made sense to provide these pieces in a shared driver.

Regards
Cyril.
