Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab1BRQvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:51:31 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38391 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1BRQv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:51:28 -0500
Message-ID: <4D5EA38D.9060804@canonical.com>
Date: Fri, 18 Feb 2011 17:51:25 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: Some hints needed how to handle SATA ALPM failures
References: <4D5E6CE1.9020908@canonical.com> <20110218145057.GM21209@htj.dyndns.org> <4D5E9681.7020809@canonical.com> <20110218161640.GR21209@htj.dyndns.org>
In-Reply-To: <20110218161640.GR21209@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 05:16 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 18, 2011 at 04:55:45PM +0100, Stefan Bader wrote:
>> Sorry that was not specific enough. It is remounting ro, which can
>> leave the fs in a better or worse state.
> 
> I see and, nope, that shouldn't lead to corrupted filesystem on a
> journaled filesystem.  I agree it sucks tho.  This shouldn't be
> happening with newer kernels unless the hardware completely shuts
> down, which some very early SATA harddrives did but shouldn't happen
> with most modern devices.  Backporting the fix isn't difficult.
> 
>>> Also, the whole LPM thing got revamped several releases ago.  Can you
>>> please test how the recent kernels behave?  There will be failures as
>>> not all hardware can handle LPM well but those failures shouldn't lead
>>> to any catastrophic failures like ro remounting of filesystem.
>>
>> The example output given as footnotes in the original post were taken from the
>> latest re-test someone did on a 2.6.38-rc5 kernel (same user also reported bad
>> experience with a 2.6.35 based kernel). The comment we got on that was:
>>
>> "Here's what i get - the drive led lights continuously for about 10 seconds
>> during which any hdd access results in hanging process:"
>>
>> [12348.040077] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x150000 action 0x6 frozen
>> [12348.040086] ata3: SError: { PHYRdyChg CommWake Dispar }
>> [12348.040091] ata3.00: failed command: READ FPDMA QUEUED
>> [12348.040099] ata3.00: cmd 60/10:00:b0:94:c5/00:00:03:00:00/40 tag 0 ncq 8192 in
>> [12348.040101] res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
>> [12348.040104] ata3.00: status: { DRDY }
>> [12348.040112] ata3: hard resetting link
>> [12348.390082] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> [12348.404414] ata3.00: configured for UDMA/133
>> [12348.404550] ata3.00: device reported invalid CHS sector 0
>> [12348.404570] ata3: EH complete
>>
>> I believe the details of the failures varied but "READ FPDMA QUEUED" and a
>> timeout were usually involved.
> 
> It's on NVIDIA ahci, right?  This shouldn't be happening with intel
> and jmb ones, which were used while implementing.  The problem is most
> likely controller dependent.  One possibility is the controller is not
> happy with DIPM.  Does specifying "medium_power" instead make the
> problem go away?  Can the bug reporter try some kernel patches?
> 

Yes, it is an Nvidia MCP67 in ahci mode. I can relay the question about
medium_power and yes we can try patches. If not the reporter, I can prepare
kernels and ask for testing.
One question in general would be whether (if it cannot be said for sure which
controller is good or not) it may be a good idea to add some whitelisting for
those known to work and disable (or limit the mode) for the unknown.

-Stefan
> Thanks.
> 

