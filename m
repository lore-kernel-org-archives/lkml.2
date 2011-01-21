Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab1AUN2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 08:28:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1AUN2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 08:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bK3uryU3Y5R+3th8VeCjbhaWFBc3wjRMMBWU6EBdvqR5XSFLS7EWbv13ir85st/srR
         +U/sp20N+Ctod09/Gl0/0FDFwywICVaEBuqA6VT86lxgJtN6Da888jp6OEyjKVwdbJtL
         31P4yF335xI19OTQjRvVWOG0vQUU/Mnw+vAfQ=
Date: Fri, 21 Jan 2011 14:28:02 +0100
From: Tejun Heo <tj@kernel.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Q. block: check bdev_read_only() from blkdev_get()
Message-ID: <20110121132802.GD2832@htj.dyndns.org>
References: <23846.1295615979@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23846.1295615979@jrobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 10:19:39PM +0900, J. R. Okajima wrote:
> 
> By the commit 75f1dc0
> 	2010-11-13 block: check bdev_read_only() from blkdev_get()
> bdev_read_only() call is added into blkdev_get().
> 
> This check makes the loopback block device unable to be mounted as
> writable once it is set to readonly, even if the corresponding is
> detached and the device becomes free.
> We may need to re-initialize the readonly/writable status flag somewhere?

Yeah, it should definitely reset r/w flag on each mount.  Interested
in fixing it?

Thanks.

-- 
tejun
