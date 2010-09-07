Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab0IGVio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:38:44 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53480 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0IGVin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=h0Fr1qFq51WWObh/yu/xAGMomBowrMllL9kVRytDZZET7WaVS6souYvao/Bnxcv6Xq
         Sf1HGSv1jcHlolPTZ+mlkq2nlWUdAmAlAMD7SjVv55FuprK0fyqpKKXiI9kSv6taa6O6
         o35EwDQWqyMc635F9eWNyrItXnnUYXDvL6+kQ=
Date: Tue, 7 Sep 2010 23:38:18 +0200
From: Dan Carpenter <error27@gmail.com>
To: mark gross <markgross@thegnar.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] pm_qos_params: cleanup: terminate a string
Message-ID: <20100907213818.GA5351@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	mark gross <markgross@thegnar.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	James Bottomley <James.Bottomley@suse.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100903124105.GJ5437@bicker> <20100907062227.GB25651@gvim.org> <20100907133805.GA20050@gvim.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907133805.GA20050@gvim.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 06:38:05AM -0700, mark gross wrote:
> >  	spin_unlock_irqrestore(&pm_qos_lock, flags);
> > @@ -374,10 +374,12 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  	} else if (count == 11) { /* len('0x12345678/0') */
> >  		if (copy_from_user(ascii_value, buf, 11))
> >  			return -EFAULT;
> > +		if (strlen(ascii_value) > 10)
>                          should be !=
> 
> > +			return -EINVAL;
> >  		x = sscanf(ascii_value, "%x", &value);
> >  		if (x != 1)
> >  			return -EINVAL;

With the original code you could do:
	char buf[11];  /* must be 11 chars */

	snprintf(buf, sizeof(buf), "0x%x", 42);
	write(fd, buf, sizeof(buf));

But the new code is stricter so the number would have to be zero padded.

regards,
dan carpenter
