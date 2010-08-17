Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0HQLcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:32:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40842 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0HQLcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kmgimqJ9GKqEhduPjm4DPn4TRBl5QPivzML/Y880b/HCqzpFazZNyeP9o/ABALbx6s
         1Sma77WuPfQg+DtFeRI0Yf0LV/iSwLIpkR21OQo0Egd0EWMiyHF15iqZEp/k4vfqh11/
         fJ9LI9oNrQ6EPSjZ1ZlCiL35nq64PpVmxWg5A=
Message-ID: <4C6A7281.3030804@gmail.com>
Date: Tue, 17 Aug 2010 13:29:05 +0200
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
References: <201007091750.05020.stephan.diestelhorst@amd.com> <201008171132.56431.stephan.diestelhorst@amd.com> <4C6A6145.7020707@gmail.com> <201008171319.25080.rjw@sisk.pl>
In-Reply-To: <201008171319.25080.rjw@sisk.pl>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 01:19 PM, Rafael J. Wysocki wrote:
> Well, I wonder what the real reason for doing the link power management
> thing at this particular point in the suspend code path is.  It just seems to
> disable the link power management, but then the controller is put into a
> low-power state and is reset from scratch during resume, so I'm not quite
> sure how skipping that code could possibly lead to any problems.

Stranger things have happened in the ATA la-la land. :-) Also, it
makes non-lpm and lpm cases leave the controller and device in
different states when it goes to sleep, which _really_ bothers me.
Combined with the timing dependent nature of DIPM, I worry this might
lead to very obscure issues and would much prefer to make sure
everything is in fixed, known, fully powered state before committing
to any major operations.  I might be paranoid tho.  I'll think more
about it.

> Perhaps we could move the link PM manipulation to the prepare stage
> of suspend?

Yeah, one possibility is that the devices misbehave if they receive
LPM commands while suspended.  Does commenting out sd_suspend resolve
the issue too?

Thanks.

-- 
tejun
