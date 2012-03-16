Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031328Ab2CPMxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:53:19 -0400
Received: from thoth.sbs.de ([192.35.17.2]:32157 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030702Ab2CPMxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:53:18 -0400
Message-ID: <4F6337AE.9000009@siemens.com>
Date: Fri, 16 Mar 2012 13:53:02 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH 3/4] kgdb: Respect that flush op is optional
References: <cover.1331900215.git.jan.kiszka@siemens.com> <08ddbfb8fbca5fef8adfce3449b5744b0db7b45f.1331900215.git.jan.kiszka@siemens.com> <4F63362E.1090701@windriver.com>
In-Reply-To: <4F63362E.1090701@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-16 13:46, Jason Wessel wrote:
> On 03/16/2012 07:17 AM, Jan Kiszka wrote:
>> Not all kgdb I/O drivers implement a flush operation. Adjust
>> gdbstub_exit accordingly.
> 
> The flush is certainly optional.  The reason we never saw this bug is because it was only used by some code not in the mainline, where it is in fact patched.  The out of tree patch hooked into the reboot notifier.
> 
> It makes me wonder if using the reboot notifier is enough vs the call backs you placed in the critical power off points in your patch [4/4].   I'll respond separately to that thread because there are other folks in the CC line.

I looked at other (granted: not kgdb-) archs and found them hooking
their machine_xxx handlers. Also, do we trigger the notifier on all
reboot/shutdown types?

> 
> If we decide to roll with this series, I will definitely merge this patch, else I will remove the code since it is not used except for out of tree patches.

Even with a reboot notifier, you still need the logic of gdbstub_exit.
So I doubt it makes sense to be removed, rather start to be used - finally.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
