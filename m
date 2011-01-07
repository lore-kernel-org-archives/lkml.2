Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab1AGSmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:42:47 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46543 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1AGSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:42:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fdMN6p32nb9UG2Qw1Lxb3kte6tpZbiItrUY6blEFRvreEyRCEYqBfzygO2jTq1R7OL
         g1xIicexO19O/mMKtJTlXg4kf8dnroCR+bbpY2rYP3E2IgwPeLFzOFDBmWRFjiBtkQ3N
         4Ld4bEiPZdf5e15Qa7BHHfmdY27wF2w4Ghk14=
MIME-Version: 1.0
In-Reply-To: <4D25AF02.60208@gmail.com>
References: <4D25AF02.60208@gmail.com>
Date: Fri, 7 Jan 2011 10:42:44 -0800
X-Google-Sender-Auth: Xs8YzW5U4lzO_lLSdusQ3dk8Hh4
Message-ID: <AANLkTimGt5hi+TpFHWxktJEg3tcDQmmARdqFqzAt++OQ@mail.gmail.com>
Subject: Re: [PATCH 01/17] pramfs: documentation
From: Tony Luck <tony.luck@intel.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 4:01 AM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> +accessed data that must survive system reboots and power cycles. An
> +example usage might be system logs under /var/log, or a user address
> +book in a cell phone or PDA.

Some usage model questions:

How do you handle errors?  I see that there are a few sanity checks in the
"mount" path ... but there would seem to be several opportunities for the
file system to get corrupted in other ways.  Since you don't have a block
device, a standard "fsck" program looks challenging (though I guess you
could mmap("/dev/mem") to peek & poke at the filesystem before trying
to mount it).  Some sort of recovery path would seem useful for the "address
book" use model ... or do you just expect users to back their address book
up (to the cloud?) and have the phone just make a clean filesystem if any
errors are found?

What about quotas?  You have a fixed amount of persistent space, and
presumably a number of apps that the user installs on their device that
may like to use pramfs to store data.  Do you need some kernel enforcement
to stop one rogue application from using up all the space? Or do you expect that
this would be handled in some library level interface that applications will
use to access pramfs?

-Tony
