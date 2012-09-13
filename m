Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2IMRvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 13:51:05 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:52455 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab2IMRvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 13:51:00 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiWMAH0cUlBV5h1yPGdsb2JhbABFhR4jhQCwOgJ6GQEBAQE3NIIgAQEFOhwTAQ8QCAMYLhQlChoTiBG7dxSKfIFig3VgA5VfhXCNGg
X-IronPort-AV: E=Sophos;i="4.80,418,1344204000"; 
   d="scan'208";a="188282545"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 13 Sep 2012 19:58:15 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/20] Input: Break out MT data
Message-ID: <20120913175815.GA3125@polaris.bitmath.org>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-2-git-send-email-rydberg@euromail.se>
 <20120913051528.GC17105@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913051528.GC17105@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:15:28PM -0700, Dmitry Torokhov wrote:
> On Sat, Sep 01, 2012 at 09:46:56PM +0200, Henrik Rydberg wrote:
> > Move all MT-related things to a separate place. This saves some
> > bytes for non-mt input devices, and prepares for new MT features.
> > 
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ...
> > @@ -1287,10 +1284,8 @@ struct input_dev {
> >  
> >  	int rep[REP_CNT];
> >  
> > -	struct input_mt_slot *mt;
> > -	int mtsize;
> > +	struct input_mt *mt;
> >  	int slot;
> > -	int trkid;
> >  
> >  	struct input_absinfo *absinfo;
> 
> Shouldn't 'slot' go into struct input_mt as well?

I wanted to remove it all together, but it turned out hairier than I
envisioned, so I left it for now. Once/if MT drivers are converted to
pass input_value arrays instead, 'slot' will disappear cleanly.

Henrik
