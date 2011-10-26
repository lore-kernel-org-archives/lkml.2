Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1JZX7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 19:59:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41914 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753589Ab1JZX7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 19:59:43 -0400
Message-ID: <1319673581.21924.31.camel@Joe-Laptop>
Subject: Re: [PATCH 1/6] Staging: hv: mousevsc: Make  boolean states  boolean
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, dmitry.torokhov@gmail.com,
        ohering@suse.com, linux-kernel@vger.kernel.org,
        virtualization@lists.osdl.org, devel@linuxdriverproject.org
Date: Wed, 26 Oct 2011 16:59:41 -0700
In-Reply-To: <20111026235054.GA31883@suse.de>
References: <1319588311-9935-1-git-send-email-kys@microsoft.com>
	 <1319588392-9982-1-git-send-email-kys@microsoft.com>
	 <1319587427.14932.7.camel@Joe-Laptop> <20111026060742.GA19973@suse.de>
	 <1319669211.21924.16.camel@Joe-Laptop> <20111026235054.GA31883@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 01:50 +0200, Greg KH wrote:
> On Wed, Oct 26, 2011 at 03:46:51PM -0700, Joe Perches wrote:
> > On Wed, 2011-10-26 at 08:07 +0200, Greg KH wrote:
> > > On Tue, Oct 25, 2011 at 05:03:47PM -0700, Joe Perches wrote:
> > > > On Tue, 2011-10-25 at 17:19 -0700, K. Y. Srinivasan wrote:
> > > > > Make some state that is boolean in nature, a boolean variable.
> > > > []
> > > > > diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
> > > > []
> > > > @@ -148,7 +148,7 @@ struct  mousevsc_prt_msg {
> > > > >   */
> > > > >  struct mousevsc_dev {
> > > > >  	struct hv_device	*device;
> > > > > -	unsigned char		init_complete;
> > > > > +	bool			init_complete;
> > > > >  	struct mousevsc_prt_msg	protocol_req;
> > > > >  	struct mousevsc_prt_msg	protocol_resp;
> > > > >  	/* Synchronize the request/response if needed */
> > > > > @@ -159,7 +159,7 @@ struct mousevsc_dev {
> > > > >  	unsigned char		*report_desc;
> > > > >  	u32			report_desc_size;
> > > > >  	struct hv_input_dev_info hid_dev_info;
> > > > > -	int			connected;
> > > > > +	bool			connected;
> > > > >  	struct hid_device       *hid_device;
> > > > >  };
> > > > One of the bools should be moved to be adjacent to the other.
> > > For a mouse driver, it really doesn't matter.
> > 'course it doesn't matter, just like whitespace
> > doesn't matter.  It's just done for form's sake.
> Not at all.
> Whitespace does matter, there is documented proof of that.
> The fact that you want to move a bool to a different part of a structure
> really is only your personal choice.  It doesn't matter for size or
> layout to make this code work better at all to do this.

Just as what you suggest is your opinion.

Whether or not 4 or 8 extra/wasted bytes in
a struct is important or not is arguable.

I think disaggregating bools is akin to
disaggregating bitfields.

Not necessarily wrong, just odd.

cheers, Joe

