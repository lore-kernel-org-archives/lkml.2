Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1BLJiy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 04:38:54 -0500
Received: from in.cluded.net ([195.159.98.120]:39711 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366Ab1BLJiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 04:38:51 -0500
Message-ID: <4D56541D.3030409@uw.no>
Date: Sat, 12 Feb 2011 09:34:21 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md: Remove risk of overflow via sprintf) by using snprintf()
 in md_check_recovery()
References: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102112227040.16994@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> sprintf() is dangerous - given the wrong source string it will overflow 
> the destination. snprintf() is safer in that at least we'll never overflow 
> the destination. Even if overflow will never happen today, code changes 
> over time and snprintf() is just safer in the long run.

> -						sprintf(nm,"rd%d", rdev->raid_disk);
> +						snprintf(nm, sizeof(nm), "rd%d", rdev->raid_disk);
>  						sysfs_remove_link(&mddev->kobj, nm);

What if "rd1234" get truncated to "rd123" and you remove the wrong link.
(No, I didn't actually bother to check how much room was allocated.)

Isn't it better to overflow than silently to unlink the wrong file?

What will happen when you try to unlink the "rd123" file again, when the 
actual 123 is meant?

Whatever the real fix is, should this be checked for at create_link time 
as well?


Daniel K.
