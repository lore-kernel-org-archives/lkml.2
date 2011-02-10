Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1BJWrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:47:07 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:56519 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757185Ab1BJWrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:47:05 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Ryan Mallon <ryan@bluewatersys.com>
Subject: Re: [PATCH 09/10] Add yaffs2 file system: Linux glue code
Date: Fri, 11 Feb 2011 11:47:02 +1300
User-Agent: KMail/1.9.10
Cc: Charles Manning <cdhmanning@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <1297221968-6747-10-git-send-email-cdhmanning@gmail.com> <4D5461A3.2040703@bluewatersys.com>
In-Reply-To: <4D5461A3.2040703@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102111147.03100.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 February 2011 11:07:31 Ryan Mallon wrote:
> On 02/09/2011 04:26 PM, Charles Manning wrote:
> > Signed-off-by: Charles Manning <cdhmanning@gmail.com>
>
> Hi Charles,
>
> More comments below. The locking I think needs some work before this is
> okay for mainline. It would be interesting to stress test yaffs on an
> SMP machine. None of the boards which we run yaffs on are though :-(.

yaffs can be run on a PC using nandsim and I have done so with the 
multi-version code. I am setting up another PC for single-version (ie. 
mainlining) testing.

I'll take an in depth look at your comments, but it is important to understand 
the locking model a bit better,

yaffs just uses one big lock. We need to consider locking for many reasons and 
need to ensure that stuff does not get modified behind our back. For example 
setattr on one object can cause garbage collection to change the flash 
location - and thus the tnode tree - of another object.

There is probably scope to change the gross locking model to a r/w lock which 
would mean that read operations could proceed better.

I did a non-open-source project of looking at finer grained locking but found 
that there were not many gains for what I looked at. Ultimately anything that 
goes to flash is serialised by the flash access.

-- Charles
