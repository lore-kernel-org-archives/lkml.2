Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1DRTwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:52:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751282Ab1DRTwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.SOC.4.64.1104181519490.1320@er3.rutgers.edu>
References: <Pine.SOC.4.64.1104150931390.1320@er3.rutgers.edu>
 <BANLkTinO+HFq+Mgg1aUz9V==zYs7qSBtDw@mail.gmail.com> <Pine.SOC.4.64.1104151122330.1320@er3.rutgers.edu>
 <BANLkTi=Gq5thZk2f1nWTz3dDA5Non8ANZg@mail.gmail.com> <20110417101731.GA17986@electric-eye.fr.zoreil.com>
 <BANLkTi=tPc6NmUuTYqbVZduNRNbE=-c34Q@mail.gmail.com> <20110418180813.GA18469@electric-eye.fr.zoreil.com>
 <BANLkTim_1OgqjCeD1a4Ay2fWJSmPHa_XTQ@mail.gmail.com> <Pine.SOC.4.64.1104181519490.1320@er3.rutgers.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2011 12:51:40 -0700
Message-ID: <BANLkTi=dke10HougmiQn9hSF15nK0B8mdA@mail.gmail.com>
Subject: Re: Suspend/resume - slow resume
To: Ciprian Docan <docan@eden.rutgers.edu>
Cc: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael, J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 12:27 PM, Ciprian Docan <docan@eden.rutgers.edu> wrote:
>
> Linus - I applied your patch and attached the diff between output of dmesg
> before and after the patch as resume_timing.diff. This patch alone does not
> seem to fix the issue;

Ok, that just means that the error return from call_usermodehelper()
gets lost somewhere along the way to kobject_uevent(). Or that I
misread the whole thing.

>  however, applying Francois's patch in addition to
> yours make the resume smooth.

Well, Francois' patch on its own should already have fixed it for you,
and made the whole issue moot.

Francois' patch is fine and improves on things, I only had a few
arguments with it. The problems I think it had were really about some
rather special cases.

                      Linus
