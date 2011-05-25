Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1EYS4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:56:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180Ab1EYS4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:56:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com>
 <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com>
 <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 11:55:57 -0700
Message-ID: <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        akpm@linux-foundation.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 11:44 AM, Parag Warudkar <parag.lkml@gmail.com> wrote:
>
> Below patch pushes the check down to ioctl functions and hopefully should
> cover more ioctl-on-gone-device cases by returning -ENXIO if an attempt
> was made to submit request to a non-running device.

Can we please not duplicate complicated logic like that?

IOW, just make a helper function for it.

That said, isn't this all *exactly* what scsi_prep_state_check() is
supposed to check for? Why isn't that called, or if called, why isn't
it doing the right thing?

                     Linus
