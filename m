Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab2HTNBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:01:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:13206 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012Ab2HTNBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:01:23 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I1447Izz1202hzz8275bhz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M921I3-01-8FW-02
X-M-MSG: 
Message-ID: <503234FA.908@amd.com>
Date: Mon, 20 Aug 2012 15:00:42 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Renninger <trenn@suse.de>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] cpufreq: Remove support for hardware P-state chips
 from powernow-k8
References: <1343305724-2809-1-git-send-email-andre.przywara@amd.com> <1343305724-2809-8-git-send-email-andre.przywara@amd.com> <201208052333.15608.rjw@sisk.pl>
In-Reply-To: <201208052333.15608.rjw@sisk.pl>
Content-Type: text/plain; charset="ISO-8859-2"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 11:33 PM, Rafael J. Wysocki wrote:
> On Thursday, July 26, 2012, Andre Przywara wrote:
>> From: Matthew Garrett <mjg@redhat.com>
>>
>> These chips are now supported by acpi-cpufreq, so we can delete all the
>> code handling them.
>>
>> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
>
> Would it be very wrong/confusing to keep that support in the powernow-k8
> driver for the time being, perhaps making it print a message that the ACPI
> driver is recommended for those chips?

Why would you like to do this? Are you concerned about regressions? Or 
do you just want to avoid the introduction of the doomed "cpb" feature 
in acpi-cpufreq?

I am not sure if keeping support in powernow-k8 would just make people 
use it still in the future. At least if it would just load easily as before.
One idea could be to keep the code around, but only load on family 10h 
if a force_fam10h or so command line option is provided. But again this 
could just push distributions to provide this option to avoid the 
transition.

One of my motivations was to keep only _one_ driver around, the code 
removal of the fam10h support from powernow-k8 supports this.

If you insist, I can keep the code in powernow-k8, but it probably 
wouldn't receive any support anymore and would increase confusion on the 
user side.

Thanks for the review,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

