Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0IBUYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:24:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36355 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab0IBUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=m+I9UEmGqDTfBE6MAsGbUlSI3Gn7hTW8ew+Htn3E/72ZJRG1Dof/dVBsx1tPPk2N5N
         rHOYiFs0m7D4YapN+rBCt4dxuMVNJB1DSkUmY7huuvOewmEmG2LhzB31Mv2LM7Cop+11
         lZ7+li2ZslN1nRyaFIBDiBKmEJucYeakauj9I=
Message-ID: <4C800829.9040802@gmail.com>
Date: Thu, 02 Sep 2010 22:25:13 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        Stephan Diestelhorst <stephan.diestelhorst@gmail.com>
Subject: Re: [PATCH] libata: skip EH autopsy and recovery during suspend
References: <201007091750.05020.stephan.diestelhorst@amd.com> <4C7F6931.4050707@gmail.com> <4C7F7649.3010409@gmail.com> <201009022216.45303.rjw@sisk.pl>
In-Reply-To: <201009022216.45303.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/02/2010 10:16 PM, Rafael J. Wysocki wrote:
> Putting the issue at hand aside, I'm not really sure if using SCSI EH for
> suspending the controller is a good idea.  It seems overly complicated and
> it doesn't match the new PCI suspend model with separate ->suspend(),
> ->freeze() and ->poweroff() callbacks.  Moreover, the passing of pm_message_t
> back and forth doesn't make things clear either.
> 
> Would it be possible to rework this thing entirely at one point?

Well, I think I would need more than that to rework the whole thing.
There are a lot of benefits in sharing the same path between probing /
error handling and suspend/resuming.  ATA has a lot of quirks which
have to be dealt with and it will be very fragile to scatter handling
logics over multiple separate paths.  We definitely can try to make
the plumbing from power management easier to follow.

Thanks.

-- 
tejun
