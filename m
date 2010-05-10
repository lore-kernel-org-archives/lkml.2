Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0EJQQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 12:16:01 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:50007 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0EJQP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 12:15:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=rn7OmR5QTQtW6BW9Nd5SjOL5/ov7YKzd0fuUS4C7/yZ4axHyeyhFWjG1s50sgMiTlo
         7kqybB5XxPtWGENO7EbgrMd4KpjK5wtdvh1b/foEh0bNXrmNwMPdx3YiMXSl3+8ptFhm
         mk78JXA9rH8rTie7G/qjb7K17Czjl0OeCiiUo=
Date: Mon, 10 May 2010 18:15:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>, Avishay Traeger <avishay@gmail.com>,
       osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] exofs: confusion between kmap() and kmap_atomic() api
Message-ID: <20100510161528.GX27064@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Boaz Harrosh <bharrosh@panasas.com>,
	Benny Halevy <bhalevy@panasas.com>,
	Avishay Traeger <avishay@gmail.com>, osd-dev@open-osd.org,
	linux-kernel@vger.kernel.org
References: <20100507090532.GD27064@bicker> <4BE68B86.50707@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE68B86.50707@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 01:16:38PM +0300, Boaz Harrosh wrote:
> On 05/07/2010 12:05 PM, Dan Carpenter wrote:
> > For kmap_atomic() we call kunmap_atomic() on the returned pointer.
> > That's different from kmap() and kunmap() and so it's easy to get them
> > backwards.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> 
> Thank you Dan, I'll push it ASAP. 
> 
> Looks like a bad bug. So this is actually a leak, right? kunmap_atomic
> would detect the bad pointer and do nothing?
> 

I've looked at it, and I think you're right but I'm not the guy to ask...

I saw somenoe else fixing these and wrote a smatch check is all.  I'm at
the "Monkey see, monkey do" level of kernel hacking.

regards,
dan carpenter

 
