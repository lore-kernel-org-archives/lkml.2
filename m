Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab0ESKMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:12:17 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:47370 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0ESKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:12:15 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BF3BA3E.3040207@jic23.retrosnub.co.uk>
Date: Wed, 19 May 2010 11:15:26 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: David Dajun Chen <Dajun.Chen@diasemi.com>
CC: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH] MFD of DA9052 Linux device drivers (1/9)
References: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
In-Reply-To: <3495EC08FA53E94AAA00CC4743D5BA7E010C20EB@pandora.diasemi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/10 10:16, David Dajun Chen wrote:
> Dear sir/madam,
> 
> The attached is the MFD part of the device drivers newly developed for DA9052 Power Management IC from Dialog Semiconductor.
> 
> Regards

Dear David,

Whilst it is good to see you have broken the da9052 support up into a number
of different patches there are still a number of issues with how this patch
set is presented that will make it difficult for anyone to review and even
harder for anyone to test (even if it is just build testing).

Firstly, the naming of the patches.  Convention says that a series of 9 like
this should probably have an explanatory cover letter. If you are using
git (if you are not, please move to it as it makes putting together large
sets like this in the right format trivial). Typically that email subject
would be

[PATCH 0/9] DA9052 driver

Then the others would be
[PATCH 1/9] DA9052 mfd
[PATCH 2/9] ....
Ideally all these patches in the series should be replies to the first email.
(If you can use git send-email it will do this nicely for you).

The next thing is that the structure at the top of the patch is very formal
and here git format-patch will do the hard work for you.

A typical git format-patch call for this series (assuming they are the last nine
patches in your tree) would look like

git format-patch --patch-with-stat --cover-letter -o for-lkml HEAD^^^^^^^^^
Then you edit the resulting files in the for-lkml directory.

Please be careful not to change the overall layout. Any comments should go
below the --- line just above the stats. Also please try to work out how
to get rid of the block disclaimer at the bottom of this email or prefix
with a line containing -- as iirc that will make git am (which applies the
patches to someone elses tree) ignore the signature.

Please review the documentation on submitting patches (in the Documentation
directory of the kernel tree) for more guidance on getting this right.

It may seem over restrictive but it saves reviewers a lot of time an hassel
and generally makes them more likely to take a look at your patches.

Jonathan

(p.s. if you are still unsure on patch formatting, feel free to send me any
patches first and I'll take a quick look for any of the things likely to annoy
other reviewers!)
