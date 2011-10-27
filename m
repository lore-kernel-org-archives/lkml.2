Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1J0AJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 20:09:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53381 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1J0AJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 20:09:42 -0400
Date: Wed, 26 Oct 2011 17:09:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
 staging
Message-ID: <20111027000926.GB6804@core.coreip.homeip.net>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
 <20111023072427.GA13268@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA3369B@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA3369B@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 03:45:14PM +0000, KY Srinivasan wrote:
> > > +
> > > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > > +	if (t == 0) {
> > > +		ret = -ETIMEDOUT;
> > > +		goto cleanup;
> > > +	}
> > > +
> > > +	response = &input_dev->protocol_resp;
> > > +
> > > +	if (!response->response.approved) {
> > > +		pr_err("synthhid protocol request failed (version %d)",
> > > +		       SYNTHHID_INPUT_VERSION);
> > > +		ret = -ENODEV;
> > > +		goto cleanup;
> > > +	}
> > > +
> > > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > 
> > We just completed the wait for this completion, why are we waiting on
> > the same completion again?
> 
> In response to our initial query, we expect the host to respond back with two
> distinct pieces of information; we wait for both these responses.

I think you misunderstand how completion works in Linux. IIRC about
Windows events they are different ;) You can not signal completion
several times and then expect to wait corrsponding number of times. Once
you signal completion is it, well, complete.

>  
> > 
> > > +	if (t == 0) {
> > > +		ret = -ETIMEDOUT;
> > > +		goto cleanup;
> > > +	}
> > > +
> > > +	/*
> > > +	 * We should have gotten the device attr, hid desc and report
> > > +	 * desc at this point
> > > +	 */
> > > +	if (input_dev->dev_info_status)
> > > +		ret = -ENOMEM;
> > 
> > -ENOMEM seems wrong.
> > 
> There are many failures here and not being able to allocate memory is the 
> primary one; and so I chose to capture that.

Any chance that these failures have their own exit paths?

Thanks.

-- 
Dmitry
