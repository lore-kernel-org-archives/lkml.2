Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2EVHpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:45:33 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:32554
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979Ab2EVHpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:45:31 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2dI9371IbafdM1432N98dKzz1202hzzz2dh2a8h668h839hd25he5bhf0ah)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
Message-ID: <4FBB4415.3090908@analog.com>
Date: Tue, 22 May 2012 09:45:25 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Johan Hovold <jhovold@gmail.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH v4] iio: add LM3533 ambient-light-sensor driver
References: <1337100396-29024-1-git-send-email-jhovold@gmail.com> <1337346461-31220-1-git-send-email-jhovold@gmail.com> <4FB75E57.9020003@kernel.org> <20120521095010.GD21033@localhost> <4FBA6F37.4000609@kernel.org>
In-Reply-To: <4FBA6F37.4000609@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 06:37 PM, Jonathan Cameron wrote:
> Michael cc'd for comments on core support of some stuff that is also
> in frequency drivers down the end of the email.
>
> On 05/21/2012 10:50 AM, Johan Hovold wrote:
>> On Sat, May 19, 2012 at 09:48:23AM +0100, Jonathan Cameron wrote:
>>> On 05/18/2012 02:07 PM, Johan Hovold wrote:
>>> So to summarise, we get the following new sysfs-entries for the ALS
>>> (where the first set replace targetX_Y):
>>>
>>> 	out_currentX_currentY_raw	r/w, (0..255), X in 0..2, Y in 0..4
>>> 	out_currentX_raw		ro (0..255), X in 0..2
>>>
>>> Is there any support in core for the first set or should I simply
>>> rename my target attributes?
> No support in the core yet for this sort of thing..
> Michael, any thoughts on this? In a sense it's very similar to
> out_altvoltageX_frequencyY_raw etc...
>
Hi,

Exactly it's similar to what we have on the DDS parts.
The DDS parts would also benefit from a second index.

Can someone think of an use case where we have 'differential' or 'modified'
together with this pattern?

If not we could use channel2 and introduce an new flag, but I fear
that we end up using channel2 for too many things.
So we should better introduce an new variable?

-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


