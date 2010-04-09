Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab0DINbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:31:18 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:54617 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab0DINbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:31:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BBF2CC4.5000303@cam.ac.uk>
Date: Fri, 09 Apr 2010 14:33:56 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: yauhen.kharuzhy@promwad.com, linux-kernel@vger.kernel.org,
       Jeff Mahoney <jeffm@suse.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH] IIO: Fix adding more than one iio device eventset
References: <1270652625-30640-1-git-send-email-yauhen.kharuzhy@promwad.com>	<4BBCCBDC.8080609@cam.ac.uk> <20100408124843.ed53e39d.akpm@linux-foundation.org>
In-Reply-To: <20100408124843.ed53e39d.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/10 20:48, Andrew Morton wrote:
> On Wed, 07 Apr 2010 19:15:56 +0100
> Jonathan Cameron <jic23@cam.ac.uk> wrote:
> 
>> Thanks for the patch.  The first bug was fixed by a patch from Sonic Zhang.
>> Andrew Morton picked it up so it is in the mm tree.  Thanks for the report
>> of this particularly horrible bug though as had been there quite a while before
>> Sonic pointed it out!
> 
> hm.  Is it a "horrible bug"?  I had assumed that it was a minor bug and
> had staged the patch for 2.6.35.  Was that a mistake?
> 
It is a bug you will only see if you attempt to bring up two iio devices
with event interfaces at the same time.  I've no idea if anyone has a, non-dev
board where this is happening. If you trigger the bug the second devices probe
will fail. So moderately horrible but the problem is fairly self contained.

By the look of it two people have run into the bug (or spotted the problem during
code review?) so probably worth pushing the fix in sooner rather than later.

Thanks,

Jonathan
