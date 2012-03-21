Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab2CUS1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:27:52 -0400
Received: from mout0.freenet.de ([195.4.92.90]:51578 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2CUS1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:27:51 -0400
From: Andreas Hartmann <andihartmann@01019freenet.de>
X-Newsgroups: linux.kernel
Subject: Re: hibernate random memory corruption, workaround i915.modeset=0
Date: Wed, 21 Mar 2012 19:15:48 +0100
Organization: privat
Message-ID: <4F6A1AD4.2030302@01019freenet.de>
References: <iz8bE-3ij-7@gated-at.bofh.it> <iGMdX-6N4-9@gated-at.bofh.it> <iGOz9-2vm-19@gated-at.bofh.it> <iHvuq-7MF-25@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
In-Reply-To: <iHvuq-7MF-25@gated-at.bofh.it>
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stanislaw!

Stanislaw Gruszka schrieb:
> On Mon, Mar 19, 2012 at 10:21:28AM -0700, Keith Packard wrote:
>> <#part sign=pgpmime>
>> On Mon, 19 Mar 2012 15:53:54 +0100, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>
>>> Keith, is there a chance that this bug can be fixed by i915 team?
>>
>> Yes, I'm working on figuring out how to actually reproduce this and then
>> work on a few work-arounds.
> 
> This must be hardware dependent then, yesterday and today I tried to
> reproduce on Lenovo T60 with:
> 
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03)
> 
> and there is no sign of corruption, I double checked if slab poisoning
> is enabled.
> 
>>> If not, can we disable hibernate on i915 with modeset=1 and add
>>> module option, which enable it for those who want to risk?
>>
>> I'd love to know if disabling modeset on just the booting kernel helps;
>> leaving the resuming kernel with modeset=1. I haven't been able to
>> reproduce this locally yet to test this theory though.
> 
> On Lenovo T500 with:
> 
> 00:02.1 Display controller [0380]: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller [8086:2a43] (rev 07)
> 
> that is the case. Script attached on previous email trigger corruption
> with modeset=1 (on various older and newer kernels) in less then 20
> iterations. There is no corruption after 100 iterations if
> i915.modeset=0 parameter is used. Some users on RH bugzilla confirmed
> that workaround as well.
> 
> If you want list of more i915 adapters where the problem happens, I can
> check in our bugzilla and provide it.

It happens too with a MSI CR620 notebook (Intel Core I5 M460):

00:02.0 VGA compatible controller: Intel Corporation Core Processor
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])


I can confirm that modeset=0 during resume doesn't activate the error.
But this is nothing new as I already wrote here[1], that the error
doesn't come up as long as kms is disabled.


Regards,
Andreas

[1] http://article.gmane.org/gmane.linux.kernel/1266499
