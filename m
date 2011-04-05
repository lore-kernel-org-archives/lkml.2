Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1DEQHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:07:17 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53988 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab1DEQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=roCuIN7JpNHuEMgtBRi8v3SmQplyc6lKOeB5mitwBQcg9qmKIAllgFmUL3j0CkeSDo
         0RUFlMSoiajF+E4vWd6kDo0RwG+knMgtPkzFUN4HhNR8YT7G5+9736wQx4fWpZ/nr+0J
         Oo+15WQBJQBLjbGNO1/vPGA72cSuhd9PvsZ9A=
Date: Tue, 5 Apr 2011 09:07:09 -0700
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: Separate out drain_workqueue() from
 destroy_workqueue()
Message-ID: <20110405160709.GA12015@mtj.dyndns.org>
References: <20110405143522.GA9621@mtj.dyndns.org>
 <1302014822.2924.0.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302014822.2924.0.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 07:47:01AM -0700, James Bottomley wrote:
> > James, does this seem to fit your use cases?
> 
> Perfectly, thanks.  It makes sure we have eliminated all work the
> workqueues generated before we return.  This is needed in some of the
> SCSI waits where we want all discovery to complete, not just the piece
> the WQ started.

Cool, applied to wq#for-2.6.40 with minor printk adjustments.  Please
feel free to pull into SCSI if necessary.  It's a stable branch and
currently contains only the single commit.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-2.6.40

Thanks.

-- 
tejun
