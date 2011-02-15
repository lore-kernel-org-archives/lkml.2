Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1BOJMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:12:49 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55194 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1BOJMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:12:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hM2KQcCpd7G/ts5nJtA0NhDbN1wyjPZzxCisgLMX/+RSF5eAbY+6JCNGvdfz/zdeQb
         ZGsTh4YATuDgOIVk5prKYDeQRdJWy9T2a2xlYAYcUcWU+u2TzcnfdXSXGdkv0oXwM7r9
         XsF/1VIMUXGtilx2pU6QSv+OaVMTzFSZ6VZHA=
Date: Tue, 15 Feb 2011 10:12:39 +0100
From: Tejun Heo <tj@kernel.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, stoth@kernellabs.com
Subject: Re: cx23885-input.c does in fact use a workqueue....
Message-ID: <20110215091239.GD3160@htj.dyndns.org>
References: <1297647322.19186.61.camel@localhost>
 <20110214043355.GA28090@core.coreip.homeip.net>
 <20110214110339.GC18742@htj.dyndns.org>
 <1297731276.2394.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297731276.2394.19.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 07:54:36PM -0500, Andy Walls wrote:
> > 1. Just flush the work items explicitly using flush_work_sync().
> 
> That will do for now.
> 
> > 2. Create a dedicated workqueue to serve as flushing domain.
> 
> I have gotten reports of the IR Rx FIFO overflows for the CX23885 IR Rx
> unit (the I2C connected one).  I eventually should either set the Rx
> FIFO service interrupt watermark down from 4 measurments to 1
> measurment, or use a kthread_worker with some higher priority to respond
> to the IR Rx FIFO service interrupt. 

Hmmm... please consider playing with WQ_HIGHPRI before going forward
with dedicated thread.

> > The first would look like the following.  Does this look correct?
> 
> Yes, your patch below looks sane to me.
> 
> Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Thanks.  Will send patch with proper description soon.

-- 
tejun
