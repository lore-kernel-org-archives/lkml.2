Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab2JAXyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:54:55 -0400
Received: from ozy.pierre-beck.de ([178.63.78.113]:60042 "EHLO
	ozy.pierre-beck.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab2JAXyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:54:53 -0400
Message-ID: <506A2D25.2040904@pierre-beck.de>
From: Pierre Beck <mail@pierre-beck.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Linux RAID <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Areca hardware RAID / first-ever SCSI bus reset: am I about to
 lose this disk controller?
References: <87mx0lsv4d.fsf@spindle.srvr.nix> <FCFB407F-9FED-4B4E-B5D9-62AB363050D2@colorremedies.com> <87r4pslpau.fsf@spindle.srvr.nix> <506A0BFB.60606@pierre-beck.de> <2A7CFE69-08F3-4C53-928C-A94907027CAC@colorremedies.com>
In-Reply-To: <2A7CFE69-08F3-4C53-928C-A94907027CAC@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Original-Recipients: lists@colorremedies.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
X-Original-Date: Tue, 02 Oct 2012 01:54:13 +0200
Date: Tue, 02 Oct 2012 01:54:47 +0200
X-Spam-Notice: Unscanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. When in degraded mode, timeout should be raised to five minutes or 
so. When in clean mode, timeout should be a tunable in milliseconds. 
Commercial RAIDs offer timeouts in ranges like 200ms - 2s. Plus a disk 
which was kicked that way should be scanned for and re-added if 
possible. With write-intent bitmaps, that would make RAIDs with aging 
disks or cables much more solid.

Also, non-degraded mode: Skip loop resets. Skip all resets actually, if 
possible. Just kick the disk. Degraded mode: Perform loop resets as it 
is now. A hung-up controller would then cause an array to degrade, but 
won't hang indefinitely. Granted, always doing loop resets keeps the 
array non-degraded, but a crashed controller is rare whilst failing 
disks are common.

linux-scsi and linux-raid should talk about this one day to make it 
happen. Requires a bit of interfacing between the layers.

On 02.10.2012 00:53, Chris Murphy wrote:
> On Oct 1, 2012, at 3:33 PM, Pierre Beck wrote:
>> It's particularly annoying when in RAID and the disk could've simply been kicked within few seconds. Something that needs improvement IMHO.
> Except that while this helps with faster recovery, you're now degraded. You wouldn't want this "fast recovery" behavior if you're at your critical number of disks remaining or you lose the array upon a few seconds worth of subsequent problems. So we kinda need context specific behavior.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

