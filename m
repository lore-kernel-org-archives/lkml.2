Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2J1CIW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 22:08:22 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:21849
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920Ab2J1CIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 22:08:21 -0400
X-Forefront-Antispam-Report: CIP:157.56.240.117;KIP:(null);UIP:(null);IPV:NLI;H:BL2PRD0610HT004.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: 10
X-BigFish: PS10(zzbb2dI98dI9371I1431Jzz1202h1d1ah1d2ahzzz2fh2a8h668h839hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh133w1155h)
Message-ID: <508C938B.6040301@convergeddevices.net>
Date: Sat, 27 Oct 2012 19:08:11 -0700
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <hverkuil@xs4all.nl>, <mchehab@redhat.com>, <sameo@linux.intel.com>,
        <perex@perex.cz>, <tiwai@suse.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] Add the main bulk of core driver for SI476x code
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net> <1351017872-32488-3-git-send-email-andrey.smirnov@convergeddevices.net> <20121025194524.GV18814@opensource.wolfsonmicro.com> <5089BC7A.80103@convergeddevices.net> <20121027213108.GD4564@opensource.wolfsonmicro.com>
In-Reply-To: <20121027213108.GD4564@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.160.178.141]
X-OriginatorOrg: convergeddevices.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2012 02:31 PM, Mark Brown wrote:
> On Thu, Oct 25, 2012 at 03:26:02PM -0700, Andrey Smirnov wrote:
>> On 10/25/2012 12:45 PM, Mark Brown wrote:
>>> This really makes little sense to me, why are you doing this?  Does the
>>> device *really* layer a byte stream on top of I2C for sending messages
>>> that look like marshalled register reads and writes?
>> The SI476x chips has a concept of a "property". Each property having
>> 16-bit address and 16-bit value. At least a portion of a chip
>> configuration is done by modifying those properties. In order to
> Right, that's what I remembered from previous code.  There's no way this
> should be a regmap bus - a bus is something that gets data serialised by
> the core into a byte stream, having the data rendered down into a byte
> stream and then reparsing it is a bit silly.  The device should be
> hooking in before the data gets marshalled which we can't currently do
> but it shouldn't be too hard to make it so that we can have register
> read and write functions supplied in the regmap config.

Oh, now I think I see what you mean. I have two agree with you, I don't
think I like what I am doing in my code.
I'll try to familiarize myself with 'regmap' code and come up with the
way to extend the framework.

And I just wanted to upstream my simple radio driver... :-)



