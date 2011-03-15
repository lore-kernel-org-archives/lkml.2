Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1COMty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:49:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63177 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab1COMtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:49:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=QdLpSL78l/zLzPXkITEVZwwUS21qF5CHf/XVQJjNqGxKtGOfbUU6c83zCaiIQkO5c4
         pG2NoLmIeE2wG6zyZbvvBKeZLXzQrZxd2APvyH/CbUdQ4s+uKrKmiJxPpJVb6aRzlcGT
         ooBqRgIuwcYivvREQR/NB4hLK5tremh4cO4Iw=
Date: Tue, 15 Mar 2011 15:48:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: rts_pstor: set lun_mode in a
 differentplace
Message-ID: <20110315124844.GY2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	wwang <wei_wang@realsil.com.cn>, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
References: <1300177336-4486-1-git-send-email-wei_wang@realsil.com.cn>
 <20110315084625.GU2008@bicker>
 <4D7F29C6.7060404@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D7F29C6.7060404@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 04:56:38PM +0800, wwang wrote:
> 于 2011年03月15日 16:46, Dan Carpenter 写道:
> > Hm...  The auto detect code is never run because chip->use_hw_setting is
> > always 0.  Are you sure the right fix isn't to set chip->use_hw_setting
> > to 1?
> >
> > regards,
> > dan carpenter
> >
> Yes, setting chip->use_hw_setting is not a wise choice.
> Normally, if chip->use_hw_setting is set to 1, more configurations will
> be turned on, such as auto_delink_en.
> auto_delink_en can only work well when pcie hotplug is configured and
> pciehp.pciehp_force is set to 1. This condition can't be met in default
> kernel config by now.
> So, I have to choose to set lun_mode detection code in a different place.
> 

Ok.   Cool.  But you're going to fix the places that use ->use_hw_setting
later on yes?  For example, the rts5288 chip has the same problem earlier
in the file where the lun_mode doesn't get set correctly. 

regards,
dan carpenter


