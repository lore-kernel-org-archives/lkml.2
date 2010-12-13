Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0LMNKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:10:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63045 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab0LMNKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Kun9W0fXSm1rrG4HsVMNfIckiRn3D9IjMOv3LQMQ04hFTsZK2/mnzl7rDugpkc10fL
         BmGivtLECEzmWOaUMui60WzHdkNxR6IhKTOEmfrmugb6U59e9GqJl0gDGliDSZK3uKXF
         KDCRnw5Wz+jTxaSZYjuoZq1a2AAyL34wDK27Q=
Date: Mon, 13 Dec 2010 16:10:22 +0300
From: Dan Carpenter <error27@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: jeffm@suse.com, linux-kernel@vger.kernel.org, brian@xyzw.org
Subject: Re: delayacct: alignment changes break iotop
Message-ID: <20101213131022.GF1620@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>, jeffm@suse.com,
	linux-kernel@vger.kernel.org, brian@xyzw.org
References: <20101213113745.GE1620@bicker>
 <20101213125709.GB14178@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101213125709.GB14178@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 06:27:09PM +0530, Balbir Singh wrote:
> Thanks for the report, looks like the change did not even bump the
> version field. Sorry, its my fault, I should have caught it earlier.
> iotop hard coding member offsets is not bad as long as we don't break
> ABI (expected from us). Any chance you could dump the offsets before
> and after the change?
>

Here is what iotop expects from iotop/data.py

    members_offsets = [
        ('blkio_delay_total', 40),
        ('swapin_delay_total', 56),
        ('read_bytes', 248),
        ('write_bytes', 256),
        ('cancelled_write_bytes', 264)
    ]

Bumping the version doesn't help, because iotop doesn't care.

What are the warning messages that prompted the change on IA64 in the
first place?  Can't we just change the format for ia64 and leave the
other arches how they were before?

regards,
dan carpenter

