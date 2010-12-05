Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab0LENIu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 08:08:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0LENIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 08:08:49 -0500
From: "Rafael J. Wysocki" <rjw@suse.com>
Organization: SUSE Labs
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Resume hangs [was: mmotm 2010-12-02-16-34 uploaded]
Date: Sun, 5 Dec 2010 14:08:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201012030107.oB317ZSW019223@imap1.linux-foundation.org> <4CFB4C66.1090106@gmail.com>
In-Reply-To: <4CFB4C66.1090106@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012051408.27730.rjw@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 05, 2010, Jiri Slaby wrote:
> On 12/03/2010 01:34 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-12-02-16-34 has been uploaded to
> 
> Hi, this kernel regresses with respect to resume. It doesn't wake up,
> the screen is black with blinking cursor at position [1, 1].
> 2010-11-23-16-12 seemed to be OK. In this one it is 100% reproducible so
> far.
> 
> I'm using pm-suspend, any ideas what to test before I start to find the
> reason on my own?

Please try the pm_test tests for core, processors and devices, eg.:

# echo core > /sys/power/pm_test
# echo mem > /sys/power/state

(this is described in Documentation/power/basic-pm-debugging.txt .

That will tell you if you need to go through the BIOS for the bug to show up
and perhaps at what "level" the problem occurs.

It looks like the problem caused by NX-ing of the kernel code.

Thanks,
Rafael
