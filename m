Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab0HQIME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:12:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50635 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab0HQIMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NkQPAequ6R9hWTolOo+zcROukTEo9N5Rrdv2y8WqZZbpT26ZE7xvxb3e7dN96Atu0F
         91EesnUbEXw2PtvS3QF/d4hRrFJBKxCqp4f3z/2IxFkODZJmnrhHsgz/HyGTJ9nbZFAy
         mIV14vgkWGm5G4tAbSUsJE9YbM3ki0Cjd1IV8=
Message-ID: <4C6A4395.8080804@gmail.com>
Date: Tue, 17 Aug 2010 10:08:53 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C52DF50.80009@kernel.org> <4C5AE1E2.6070601@gmail.com> <201008170951.26073.stephan.diestelhorst@amd.com>
In-Reply-To: <201008170951.26073.stephan.diestelhorst@amd.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 09:51 AM, Stephan Diestelhorst wrote:
> On Thursday 05 August 2010 18:08:02 Tejun Heo wrote:
>> Can you please try the following patch and see whether the problem
>> goes away?
> 
> I've finally managed to get this to compile and test. (Hit a bug with
> Debian's make-kpkg and other nuisances...)
> 
> The problem is still there. On some resumes I get the dreadful dead
> disk again:
> 
> end_request: I/O error , dev sda sector ...
> sd 0:0:0:0: [sda] Unhandled error code
> sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 0e a4 77 a8 0 00 08 00
> (many of those)
> 
> Can't access /var/log/messages right now, due to broken I/O. Will try
> to trigger it again and check for the qc timeout messages..

Yeah, it would great to have the log.  So, it seems like the hardware
is actually buggy then.  :-(

Thanks.

-- 
tejun
