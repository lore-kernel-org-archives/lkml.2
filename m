Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863Ab2JaV6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 17:58:32 -0400
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:54180 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760677Ab2JaV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 17:58:30 -0400
Message-ID: <50919EED.3020601@genband.com>
Date: Wed, 31 Oct 2012 15:58:05 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <20121031171743.GA17652@srcf.ucam.org> <20121031173919.4fc63ddd@pyramind.ukuu.org.uk> <2548314.3caaFsMVg6@linux-lqwf.site>
In-Reply-To: <2548314.3caaFsMVg6@linux-lqwf.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2012 21:58:06.0288 (UTC) FILETIME=[CEA95D00:01CDB7B2]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19326.001
X-TM-AS-Result: No--19.560000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 02:14 PM, Oliver Neukum wrote:
> On Wednesday 31 October 2012 17:39:19 Alan Cox wrote:
>> On Wed, 31 Oct 2012 17:17:43 +0000
>> Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>
>>> On Wed, Oct 31, 2012 at 05:21:21PM +0000, Alan Cox wrote:
>>>> On Wed, 31 Oct 2012 17:10:48 +0000
>>>> Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>>>>> The kernel is signed. The kernel doesn't check the signature on the
>>>>> suspend image.
>>>>
>>>> Which doesn't matter. How are you going to create the tampered image in
>>>> the first place ?
>>>
>>> By booting a signed kernel, not turning on swap and writing directly to
>>> the swap partition.
>>
>> Ok so the actual problem is that you are signing kernels that allow the
>> user to skip the S4 resume check ?
>
> No. The problem is principal in nature.
>
> swapoff /dev/sdb6 ; dd if=/tmp/malicious_image of=/dev/sdb6 ; sync ; reboot
>
> That would do it on my system.
> Maybe in theory you could solve this by the kernel invalidating images
> it hasn't written itself and forbidding to change the resume partition from the
> kernel command line, but that would break user space hibernation.

If the resuming kernel refuses to resume from images it didn't create 
itself, why do you need to forbid changing the resume partition from the 
kernel command line?

Chris
