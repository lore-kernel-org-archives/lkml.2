Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab0E0Io5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 04:44:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757336Ab0E0Io4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 04:44:56 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] idle-test patches queued for upstream
Date: Thu, 27 May 2010 10:45:33 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
In-Reply-To: <1274928151-30919-1-git-send-email-lenb@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005271045.33500.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010 04:42:23 Len Brown wrote:
> Please look over and test this patch set.
> (If you test linux-next, you already have it)
> 
> There are a few simple patches, leading up to a new intel_idle driver.
> 
> Note that you can get the patch series as a single patch here:
> http://ftp.kernel.org/pub/linux/kernel/people/lenb/idle/patches/2.6.34/idle-test-2.6.34.diff.gz
> 
> or pull from this git branch
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-idle-2.6.git idle-test
> 
> Both are vs 2.6.34.
> 
> Why is it good to have a native intel_idle driver?
> 
> Basically, we think we can do better than ACPI.
Why exactly? Is there any info missing in the ACPI tables?
Or is this just to be more independent from OEMs?

> Indeed, on my (production level commerically available) Nehalem desktop
> the ACPI tables are broken and an ACPI OS idles at 100W.  With this
> driver the box idles at 85W.
What exactly was broken there?

IMO this is a step backward.
CPUfreq runs rather well on nearly every machine supporting it without
tons of static frequency tables in kernel. Even powernow-k8 might get merged
into acpi-cpufreq.

Intel set up a huge ACPI API for this and now it's not used anymore?!?
Will these parts get obsoleted in a future spec?
While for C-states there are not that many static entries needed, another
drawback could be that OEMs will disable/hide C-states on purpose.

Using ACPI table based C-states by default and using intel_idle.enable=1
or similar for workarounds sounds safer.
At least as long as the driver is experimental.

Does Windows use ACPI C-state info for idle?

Thanks,

   Thomas
