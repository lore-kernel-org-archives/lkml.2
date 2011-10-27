Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088Ab1J0Eb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 00:31:28 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58185 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1J0Eb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 00:31:26 -0400
Date: Wed, 26 Oct 2011 21:31:20 -0700
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
Message-ID: <20111027043120.GA15725@core.coreip.homeip.net>
References: <1318658907-16698-1-git-send-email-kys@microsoft.com>
 <20111023072427.GA13268@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA3369B@TK5EX14MBXC126.redmond.corp.microsoft.com>
 <20111027000926.GB6804@core.coreip.homeip.net>
 <6E21E5352C11B742B20C142EB499E0481AA51BAB@TK5EX14MBXC122.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481AA51BAB@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 01:19:50AM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Wednesday, October 26, 2011 8:09 PM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org; linux-
> > input@vger.kernel.org; Haiyang Zhang; Jiri Kosina
> > Subject: Re: [PATCH 1/1] Staging: hv: mousevsc: Move the mouse driver out of
> > staging
> > 
> > On Sun, Oct 23, 2011 at 03:45:14PM +0000, KY Srinivasan wrote:
> > > > > +
> > > > > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > > > > +	if (t == 0) {
> > > > > +		ret = -ETIMEDOUT;
> > > > > +		goto cleanup;
> > > > > +	}
> > > > > +
> > > > > +	response = &input_dev->protocol_resp;
> > > > > +
> > > > > +	if (!response->response.approved) {
> > > > > +		pr_err("synthhid protocol request failed (version %d)",
> > > > > +		       SYNTHHID_INPUT_VERSION);
> > > > > +		ret = -ENODEV;
> > > > > +		goto cleanup;
> > > > > +	}
> > > > > +
> > > > > +	t = wait_for_completion_timeout(&input_dev->wait_event, 5*HZ);
> > > >
> > > > We just completed the wait for this completion, why are we waiting on
> > > > the same completion again?
> > >
> > > In response to our initial query, we expect the host to respond back with two
> > > distinct pieces of information; we wait for both these responses.
> > 
> > I think you misunderstand how completion works in Linux. IIRC about
> > Windows events they are different ;) You can not signal completion
> > several times and then expect to wait corrsponding number of times. Once
> > you signal completion is it, well, complete.
> 
> Looking at the code for complete(), it looks like the "done" state is incremented
> each time complete() is invoked and  the  code for do_wait_for_common() decrements the 
> done state each time it is invoked (if the completion is properly signaled and we are not dealing
> with a timeout. So, what am I missing here.

Hmm, you are right. I am not sure why I thought that completion has to
be re-initialized before it can be reused... I guess this is true only
if one uses complete_all().

-- 
Dmitry
