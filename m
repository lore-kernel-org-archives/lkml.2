Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0JUH3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:29:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34370 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0JUH3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:29:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LVCLjxLTBWVEh0gw8kaTEktaEZcbugAgxKg8AkbgJXrFcGjhUlk3XzUjgRx1vyv0pE
         MqW9hX1WNrSUAmKAs2DAZs6t3spB9ZAkaL6ZzOuDpaqF8XQpRvj943Sdg6r7/N52yzJb
         CeMsnZmk5qFbvGhj1r0nEBcWG1olccWyKJPgo=
Date: Thu, 21 Oct 2010 09:29:39 +0200
From: Dan Carpenter <error27@gmail.com>
To: Achim Leubner <achim_leubner@adaptec.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] gdth: integer overflow in ioctl
Message-ID: <20101021072939.GF5985@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Achim Leubner <achim_leubner@adaptec.com>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20101008070307.GF11681@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101008070307.GF11681@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 09:03:07AM +0200, Dan Carpenter wrote:
> gdth_ioctl_alloc() takes the size variable as an int.
> copy_from_user() takes the size variable as an unsigned long.
> gen.data_len and gen.sense_len are unsigned longs.
> On x86_64 longs are 64 bit and ints are 32 bit.
> 
> We could pass in a very large number and the allocation would truncate
> the size to 32 bits and allocate a small buffer.  Then when we do the
> copy_from_user(), it would result in a memory corruption.
> 
> CC: stable@kernel.org
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

I never know if anyone gets my emails and so I has a small sad face on
the front of my head here: --------------->   :(

regards,
dan carpenter


