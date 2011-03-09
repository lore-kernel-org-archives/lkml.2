Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab1CIS7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:59:17 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57181 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1CIS7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZhqTZyRufgtZUiu/+bMF3VlcqG1NVCRzjjAPr3o4kAPG9L1dNYp4dDgroZ7TSgDJ4Z
         8gUdkDz6JzVhNFL6TLGDFuWIilEDwCQE/GqVBNnMTx1sPblPRerE0Z+eDEWDApD+bmBA
         upa2FW7kJOIf5g59Qp5mJ0fTyYfS0gBI9cKzo=
Date: Wed, 9 Mar 2011 19:59:09 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: block: Fix oops caused by __blkdev_get() calling
 disk_unblock_events() with invalid @disk
Message-ID: <20110309185909.GA13729@mtj.dyndns.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
 <4D774641.3070806@kernel.dk>
 <4D779396.7050905@fusionio.com>
 <20110309153859.GD27010@htj.dyndns.org>
 <4D77C664.3080803@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D77C664.3080803@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 07:26:44PM +0100, Jens Axboe wrote:
> >   This is fixed by moving reference putting after open success is
> >   determined and not clearing @disk to %NULL.  On success, @disk is
> >   valid because there is another opener holding reference to it.  On
> >   failure, the references are put after disk_unblock_events() is
> >   called.
> 
> Thanks, applied. A bit unfortunate to have a 100% crasher in the tree,
> though. Will suck for bisects.

Yeah, that does suck.  I folded in the fix to the offending commit and
regenerated the tree in case you want to rebase the tree.

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git disk-event-convert-fixed

Thank you.

-- 
tejun
