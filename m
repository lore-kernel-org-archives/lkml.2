Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2K2GYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:24:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58737 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2K2GYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:24:20 -0500
Date: Wed, 28 Nov 2012 22:21:04 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>,
        Michal Hocko <mhocko@suse.cz>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [RFC] Add mempressure cgroup
Message-ID: <20121129062104.GA22841@lizard>
References: <20121128102908.GA15415@lizard>
 <20121129061412.GA26034@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121129061412.GA26034@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:14:13AM +0200, Kirill A. Shutemov wrote:
> On Wed, Nov 28, 2012 at 02:29:08AM -0800, Anton Vorontsov wrote:
> > +static int mpc_pre_destroy(struct cgroup *cg)
> > +{
> > +	struct mpc_state *mpc = cg2mpc(cg);
> > +	int ret = 0;
> > +
> > +	mutex_lock(&mpc->lock);
> > +
> > +	if (mpc->eventfd)
> > +		ret = -EBUSY;
> 
> cgroup_rmdir() will unregister all events for you. No need to handle it
> here.

Okie, thanks!

[...]
> > +static int mpc_register_level_event(struct cgroup *cg, struct cftype *cft,
> > +				    struct eventfd_ctx *eventfd,
> > +				    const char *args)
> > +{
> > +	struct mpc_state *mpc = cg2mpc(cg);
> > +	int i;
> > +	int ret;
> > +
> > +	mutex_lock(&mpc->lock);
> > +
> > +	/*
> > +	 * It's easy to implement multiple thresholds, but so far we don't
> > +	 * need it.
> > +	 */
> > +	if (mpc->eventfd) {
> > +		ret = -EBUSY;
> > +		goto out_unlock;
> > +	}
> 
> One user which listen for one threashold per cgroup?
> I think it's wrong. It's essensial for API to serve multiple users.

Yea, if we'll consider merging this, I'll definitely fix this. Just didn't
want to bring the complexity into the code.

Thanks,
Anton.
