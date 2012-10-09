Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2JIXGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:06:15 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:50807
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756910Ab2JIXGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:06:11 -0400
X-Forefront-Antispam-Report: CIP:157.56.244.229;KIP:(null);UIP:(null);IPV:NLI;H:CH1PRD0610HT001.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzzz2fh2a8h668h839hd25he5bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <5074ADE4.1000302@convergeddevices.net>
Date: Tue, 9 Oct 2012 16:06:12 -0700
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <hverkuil@xs4all.nl>, <mchehab@redhat.com>, <sameo@linux.intel.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] Add the main bulk of core driver for SI476x code
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <1349488502-11293-3-git-send-email-andrey.smirnov@convergeddevices.net> <20121009063349.GN8237@opensource.wolfsonmicro.com>
In-Reply-To: <20121009063349.GN8237@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.160.178.141]
X-OriginatorOrg: convergeddevices.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 11:33 PM, Mark Brown wrote:
> On Fri, Oct 05, 2012 at 06:54:58PM -0700, Andrey Smirnov wrote:
>
>> +			err = regulator_enable(core->supplies.va);
>> +			if (err < 0)
>> +				break;
>> +			
>> +			err = regulator_enable(core->supplies.vio2);
>> +			if (err < 0)
>> +				goto disable_va;
>> +
>> +			err = regulator_enable(core->supplies.vd);
>> +			if (err < 0)
>> +				goto disable_vio2;
>> +			
>> +			err = regulator_enable(core->supplies.vio1);
>> +			if (err < 0)
>> +				goto disable_vd;
> If the sequencing is critical here you should have comments explaining
> what the requirement is, otherwise this looks like a prime candidate
> for conversion to regulator_bulk_enable() (and similarly for all the
> other regulator usage, it appears that all the regulators are worked
> with in a bulk fashion).
>

Unfortunately the datasheet is not very clear on the subject. My
suspicion at the time of writing was that since there are multiple power
domains that it was possible to power up only the ones required for
specific subsystem in use. Unfortunately I didn't and still don't have
the hardware to test it on(on the board I use there are no dedicated
regulators and the chips are always powered on). I'll convert it to the
code that uses regulators in bulk fashion.

Andrey Smirnov

