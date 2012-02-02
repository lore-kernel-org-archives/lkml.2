Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2BBDCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:02:34 -0500
Received: from fnarfbargle.com ([93.93.131.224]:50263 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753586Ab2BBDCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:02:32 -0500
Message-ID: <4F29FCB2.6040204@fnarfbargle.com>
Date: Thu, 02 Feb 2012 11:02:10 +0800
From: Brad Campbell <brad@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: thomas@fjellstrom.ca
CC: John Robinson <john.robinson@anonymous.org.uk>,
        linux-raid <linux-raid@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: GRUB doesn't like ServeRAID M1015/LSI 9220-8i (was Re: mvsas
 with 3.1)
References: <201201131144.58044.thomas@fjellstrom.ca> <201202010703.09833.thomas@fjellstrom.ca> <4F294E64.10204@anonymous.org.uk> <201202010742.07818.thomas@fjellstrom.ca>
In-Reply-To: <201202010742.07818.thomas@fjellstrom.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.2.80
X-SA-Exim-Mail-From: brad@fnarfbargle.com
X-SA-Exim-Scanned: No (on localhost); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/12 22:42, Thomas Fjellstrom wrote:
>
> Yeah, GRUB immediately throws an "out of memory. Aborted" error, its annoying,
> but I reported the issue on GRUB's bug tracker after talking to a guy in #grub
> on freenode. Hopefully someone looks at it soon. It appears it happens so
> early in grub's startup that it can't even output any debug info (I was asked
> to run: `grub-install --debug-image=all /dev/sdX`, and did so, I get debug
> output when the card is not installed, but absolutely nothing when it is
> installed.

Just another data point. I've seen this issue also. It does not appear to be GRUB's fault. It 
appears the BIOS on the card does something funky as it also prevents syslinux/isolinux/pxelinux and 
its friends from properly detecting/reporting the machines memory. Machine has 16GB but a PXE boot 
believes it has 3GB.

I "worked around" the problem by swapping out the mainboard for a later model with a different BIOS 
and the problem went away. Not pretty, but it was the only way I could get the machine to boot with 
those cards in it. I have 4 IBM cards in 2 machines and they work fine here. I still have the dodgy 
mainboard and can set it up if you need help testing/reproducing the issue.

Regards,
Brad


