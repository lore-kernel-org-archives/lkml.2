Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1BRPzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:55:53 -0500
Received: from adelie.canonical.com ([91.189.90.139]:48397 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1BRPzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:55:49 -0500
Message-ID: <4D5E9681.7020809@canonical.com>
Date: Fri, 18 Feb 2011 16:55:45 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: Some hints needed how to handle SATA ALPM failures
References: <4D5E6CE1.9020908@canonical.com> <20110218145057.GM21209@htj.dyndns.org>
In-Reply-To: <20110218145057.GM21209@htj.dyndns.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2011 03:50 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 18, 2011 at 01:58:09PM +0100, Stefan Bader wrote:
>> We are hoping that those working more closely with the SATA code might
>> be aware of this issue.  As the symptoms are so severe (data corruption)
>> we have ALPM disabled globally, but this does make it hard to get more
>> targeted information on affected platforms.
> 
> What do you mean by data corruption?  File system ro remount or actual
> fs corruption?  If actual fs corruption is happening, it's highly
> likely that there's an underlying issue with the hardware.  If data
> corruption can be reproduced, can you please run smartctl -a before
> and after such failure and post the outputs?
> 

Sorry that was not specific enough. It is remounting ro, which can leave the fs
in a better or worse state.

> As for ro remounts, I recall applying fixes for that months ago.  I
> don't remember the details but some configurations raised extra PHY
> event afterwards and command was failed without retry.  Anyways, it
> got fixed.  Please dig through the log for details.
> 
> Also, the whole LPM thing got revamped several releases ago.  Can you
> please test how the recent kernels behave?  There will be failures as
> not all hardware can handle LPM well but those failures shouldn't lead
> to any catastrophic failures like ro remounting of filesystem.
>

The example output given as footnotes in the original post were taken from the
latest re-test someone did on a 2.6.38-rc5 kernel (same user also reported bad
experience with a 2.6.35 based kernel). The comment we got on that was:

"Here's what i get - the drive led lights continuously for about 10 seconds
during which any hdd access results in hanging process:"

[12348.040077] ata3.00: exception Emask 0x0 SAct 0x1 SErr 0x150000 action 0x6 frozen
[12348.040086] ata3: SError: { PHYRdyChg CommWake Dispar }
[12348.040091] ata3.00: failed command: READ FPDMA QUEUED
[12348.040099] ata3.00: cmd 60/10:00:b0:94:c5/00:00:03:00:00/40 tag 0 ncq 8192 in
[12348.040101] res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
[12348.040104] ata3.00: status: { DRDY }
[12348.040112] ata3: hard resetting link
[12348.390082] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[12348.404414] ata3.00: configured for UDMA/133
[12348.404550] ata3.00: device reported invalid CHS sector 0
[12348.404570] ata3: EH complete

I believe the details of the failures varied but "READ FPDMA QUEUED" and a
timeout were usually involved.

Stefan

> Thanks.
> 

