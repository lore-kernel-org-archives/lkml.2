Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2FSIQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:16:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42428 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab2FSIP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:15:59 -0400
Message-ID: <4FE03539.7060005@gmail.com>
Date: Tue, 19 Jun 2012 16:15:53 +0800
From: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Bernhard Voelker <mail@bernhard-voelker.de>
CC: Jens Axboe <axboe@kernel.dk>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        util-linux@vger.kernel.org
Subject: Re: Why does ionice(1) ban the user to set back to 'none' class?
References: <20120618114841.GA4855@gmail.com> <4FDF2D10.9050008@kernel.dk> <4FDFDFCE.9010307@gmail.com> <4FE01ED8.8000903@bernhard-voelker.de>
In-Reply-To: <4FE01ED8.8000903@bernhard-voelker.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 02:40 PM, Bernhard Voelker wrote:

> That has already been fixed by commit v2.15-45-g5dc9371 more than 2 years ago:
> 
>   Author: Jakob Unterwurzacher <jakobunt@gmail.com>  2009-01-17 02:38:32
>   Committer: Karel Zak <kzak@redhat.com>  2009-05-27 23:43:18
> 
> and the change made it into 2.16.
> 
> The current piece of code looks like this:
> 
> 	switch (ioclass) {
> 		case IOPRIO_CLASS_NONE:
> 			if ((set & 1) && !tolerant)
> 				warnx(_("ignoring given class data for none class"));
> 			data = 0;
> 			break;
> 		case IOPRIO_CLASS_RT:
> 		case IOPRIO_CLASS_BE:
> 			break;
> 
> We'are currently at version 2.21.2.

Thanks for pointing out it.  I use ionice(1) in rhel5 and its version is
2.13. :-p

Obviously, Documentation/block/ioprio.txt is out of date.  Later I will
send a patch to fix it.

Regards,
Zheng
