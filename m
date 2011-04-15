Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1DONZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:25:30 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:39522 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1DONZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:25:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DA847B9.70902@cam.ac.uk>
Date: Fri, 15 Apr 2011 14:27:21 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, greg@kroah.com, rusty@rustcorp.com.au,
        adobriyan@gmail.com
Subject: Re: [RFC PATCH 0/3 V2] Introduce usr_strtobool (previously kstrtobool)
References: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no one has any comments on this, who is likely to pick it up?
> Here is a second pass at introducing a new function to unify
> code that is attempting to get a boolean value from user input strings.
> 
> The first attempt (other than having some stupid bugs) was opposed by
> Alexy Dobriyan on the basis that it did completely insufficient checking
> on the string.  Given that under the original proposed name it was
> associated with the other kstrto* functions it was reasonable to assume
> if would be as strict as they are.  Hence the name change to remove
> an implication of this.
> 
> The use cases are both the pair below and the numerous boolean
> attributes in sysfs.  It's for these that I'm personally interested
> in having such a function, but as Greg pointed out a good starting
> point is to unify the places where this is already occuring.
> 
> The big questions to my mind are:
> 
> 1) Is the usr_strtobool name a good choice?
> 2) Should we introduce other acceptable boolean inputs?
>    Clearly there are issues in changing the list as it will at least
>    in theory change the two api's effected by this series.
> 
> Thanks,
> 
> Jonathan
> 
> Jonathan Cameron (3):
>   Add a usr_strtobool function matching semantics of existing in kernel
>     equivalents
>   debugfs: move to new usr_strtobool
>   params.c: Use new usr_strtobool function to process boolean inputs
> 
>  fs/debugfs/file.c      |   20 ++++++--------------
>  include/linux/string.h |    1 +
>  kernel/params.c        |   14 ++++----------
>  lib/string.c           |   29 +++++++++++++++++++++++++++++
>  4 files changed, 40 insertions(+), 24 deletions(-)
> 

