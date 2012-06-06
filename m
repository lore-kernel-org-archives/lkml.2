Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab2FFW4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:56:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53727 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab2FFW4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:56:44 -0400
Message-ID: <4FCFE028.10005@gmail.com>
Date: Wed, 06 Jun 2012 17:56:40 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 1/2] edac: add support for Calxeda highbank memory controller
References: <1339020125-20198-1-git-send-email-robherring2@gmail.com> <1339020125-20198-2-git-send-email-robherring2@gmail.com> <4FCFDB12.3090403@redhat.com>
In-Reply-To: <4FCFDB12.3090403@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro,

On 06/06/2012 05:34 PM, Mauro Carvalho Chehab wrote:
> Hi Rob,
> 
> Em 06-06-2012 19:02, Rob Herring escreveu:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Add support for memory controller on Calxeda Highbank platforms. Highbank
>> platforms support a single 4GB mini-DIMM with 1-bit correction and 2-bit
>> detection.
>>

[snip]

>> +
>> +	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
>> +	layers[0].size = 1;
>> +	layers[0].is_virt_csrow = true;
>> +	layers[1].type = EDAC_MC_LAYER_CHANNEL;
>> +	layers[1].size = 1;
>> +	layers[1].is_virt_csrow = false;
>> +	mci = edac_mc_alloc(0, ARRAY_SIZE(layers), layers,
>> +			    sizeof(struct hb_mc_drvdata));
> 
> Hmm... I suspect that memories by DIMM chip select/channel at Calxeda,
> as it is using just 1 cs/channel. It probably makes more sense to add new layer
> type(s) to properly represent the way your memory controller addresses it, if
> Calxeda doesn't work with DIMMs.

Not sure I follow. DIMMs are supported, but only a newer JEDEC form
factor (DDR3 72-bit mini DIMM). The h/w pretty much fixed to a single
4GB DIMM. The controller is 1 72-bit channel.

Rob
