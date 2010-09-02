Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab0IBUdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:33:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55863 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0IBUdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=V89J5HKHddASSqDbpadvZEUpVR6fCD/PCTlzYUWZSN78ALSglV/7YvvnpBLRnTzlr0
         cERtEhurNsRkzeMRLKcG2QBIBnEBEa5mNISMmgSw6r/Fsch8/CO8TrMh8STwgDT9qqoQ
         EUL516jIA31J9f6st2Ga++YJHALYhTAQCAx8k=
Message-ID: <4C800A31.3050401@gmail.com>
Date: Thu, 02 Sep 2010 22:33:53 +0200
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
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201009022216.45303.rjw@sisk.pl> <4C800829.9040802@gmail.com> <201009022228.07626.rjw@sisk.pl>
In-Reply-To: <201009022228.07626.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/02/2010 10:28 PM, Rafael J. Wysocki wrote:
> That would be very nice.  In particular, I'd like to get rid of the
> pm_message_t thing if possible.  And I'd like to avoid putting the
> controller into D3 before creating hibernation image. :-)

Oh, yeah, things like that can definitely be changed, but I think it
would still need to be piped through EH.  That's how the queue gets
quiesced for those special operations and resume is basically probing,
so it doesn't make much sense to split them.  Please let me know how
it should work from power management POV and I'll be happy to convert
libata to fit the new behavior.

Thanks.

-- 
tejun
