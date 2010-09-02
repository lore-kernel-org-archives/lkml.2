Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab0IBJHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 05:07:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab0IBJHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 05:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qCWDQZhbBT/AjqwsN7G0mEaeQRJPKZOxqHIRJ1UHzQSMkCgKHVgvNbPu0+08dQeqhl
         kjpdivmOBjT/l7+cBll0PXoPlkCUBw7IUFu+ZLY6O/slevMxMgp2FwfTLSx0wd89lFtE
         A83XSA8fNaCSzdWHl18jMKZY66qOsl3BW6kfU=
Message-ID: <4C7F6931.4050707@gmail.com>
Date: Thu, 02 Sep 2010 11:06:57 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] SATA / AHCI: Do not play with the link PM during suspend
 to RAM
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C7376BE.5040006@gmail.com> <201008242239.43249.rjw@sisk.pl> <201008270109.36687.rjw@sisk.pl>
In-Reply-To: <201008270109.36687.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On 08/27/2010 01:09 AM, Rafael J. Wysocki wrote:
> Well, no luck.  I was able to reproduce the issue on my box with this patch
> applied on top of 2.6.32-rc2.
> 
> Which probably means that the link power management is not really involved
> here and seems to turn up this statement:
> 
> rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
> 
> in ata_host_suspend() as the culprit.
> 
> Does it make sense?

So, LPM doesn't have anything to do with the problem.  The fact that
this only happens on specific machines is strange.  Maybe the BIOS is
doing something fishy to the controller on disk spindown during
suspend.  Can the BIOS tell that the system is going for suspend by
the time sd suspend is called?  I'll prep another patch which will
make EH skip certain steps and ignore failures during suspend, which
basically mimics what your patch does but in safer way.

Thanks.

-- 
tejun
