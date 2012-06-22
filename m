Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab2FVLD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:03:28 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4701 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757847Ab2FVLD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:03:27 -0400
Message-ID: <1340363005.1773.86.camel@x61.thuisdomein>
Subject: Re: finding unused header files
From: Paul Bolle <pebolle@tiscali.nl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ysato@users.sourceforge.jp
Date: Fri, 22 Jun 2012 13:03:25 +0200
In-Reply-To: <alpine.DEB.2.02.1206220641150.6493@oneiric>
References: <alpine.DEB.2.02.1206220641150.6493@oneiric>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Jun 2012 11:03:25.0648 (UTC) FILETIME=[A5761D00:01CD5066]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 06:46 -0400, Robert P. J. Day wrote:
> inspired by that last post that located an unused header file under
> arch/h8300, i ran my "find_unused_headers.sh" script on the same
> sub-directory to see what would show up.
> 
>   the script is stupidly conservative and didn't identify that shm.h
> header since *somewhere* in the entire kernel source tree, someone was
> including a file called "shm.h" -- not even for the same architecture.
> like i said, stupidly conservative.
> 
>   but it did find this:
> 
> $ ../s/find_unused_headers.sh arch/h8300
> ===== target_time.h =====
> ./arch/h8300/include/asm/target_time.h
> $
> 
> and i see nothing anywhere in the entire tree that includes a
> target_time.h header under any circumstances.

See my patch "h8300: delete
target_time.h" (https://lkml.org/lkml/2012/6/8/518 ). I don't remember
getting a reply to that message.

>   i should probably do another run of these scripts some day, just to
> see what turns up.

The script I use currently shows almost 200 (potentially) unused
headers. It's not very sophisticated and errs on the safe side (ie, it
must show absolutely no sign of files including the header). I'm not
sure whether a sophisticated approach is actually feasible.

In the last weeks I send patches to remove a few dozen of those 200
headers.


Paul Bolle

