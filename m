Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1LNBfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:35:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:46574 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab1LNBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:35:43 -0500
Message-ID: <4EE7FD6A.1010700@gmail.com>
Date: Wed, 14 Dec 2011 12:35:38 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/29] Staging: comedi: fix printk issue in dt3000.c
References: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
In-Reply-To: <1323667181-17252-1-git-send-email-ravishankar.km@greenturtles.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 16:19, Ravishankar karkala Mallikarjunayya wrote:

> This is a patch to the dt3000.c file that fixes up a
> printk warning found by the checkpatch.pl tool.
> 
> Converted printks to dev_<levels>.
> 
> Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>


There are still numerous issues with these patches, some which have been
pointed out to you several times now and still exist:

 - You are using printk/pr_info, etc where dev_info, etc should be used
 - You are converting some KERN_CONT to multiline dev_info, and in doing
so are now printing useless strings.
 - Some of the printk's you are 'fixing' should just get removed. Don't
blindly replace things, it just creates churn.
 - You are converting some printks to dev_dbg and leaving dev->minor in
the string which is no longer needed.
 - There are some subtle format changes introduced by the printk
changes. Not a big deal, but it should be noted in the changelog. It
might affect some userspace tools for the comedi drivers?
 - You have multiple patches which do the same thing. Why are there two
patches for converting printk -> dev_dbg in das1800.c for example? Why
not do all of the conversion changes for one file in a single patch?
 - Some of your patches don't do what they say they do.
 - You have compile errors still.

Some these patches probably are worth applying, but they are just lost
in the noise.

~Ryan
