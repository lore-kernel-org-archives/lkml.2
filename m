Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2GRSwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 14:52:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63591 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2GRSwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 14:52:39 -0400
Date: Wed, 18 Jul 2012 11:50:30 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH] pstore/ftrace: Convert to its own enable/disable debugfs
 knob
Message-ID: <20120718185029.GA4184@lizard>
References: <20120710001004.GA22744@lizard>
 <1341879046-5197-3-git-send-email-anton.vorontsov@linaro.org>
 <1342553898.10332.9.camel@gandalf.stny.rr.com>
 <20120717200130.GA31678@lizard>
 <1342561102.10332.18.camel@gandalf.stny.rr.com>
 <20120718034722.GA18081@lizard>
 <5006EE8C.20304@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5006EE8C.20304@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 10:12:44AM -0700, Stephen Boyd wrote:
> On 07/17/12 20:47, Anton Vorontsov wrote:
> > +
> > +	file = debugfs_create_file("record_ftrace", 0600, dir, NULL,
> > +				   &pstore_knob_fops);
> > +	if (IS_ERR_OR_NULL(file)) {
> > +		err = PTR_ERR(file);
> > +		pr_err("%s: unable to create pstore/ftrace file: %d\n",
> > +		       __func__, err);
> > +		goto err_file;
> > +	}
> 
> debugfs only returns NULL on failure.

Well, techincally, with DEBUG_FS=y, yes. (And we have dependency on
it.)

But see include/linux/debugfs.h for DEBUG_FS=n case:

static inline struct dentry *debugfs_create_file(const char *name, umode_t mode,
                                        struct dentry *parent, void *data,
                                        const struct file_operations *fops)
{
        return ERR_PTR(-ENODEV);
}

So, I think it is fine to check for IS_ERR_OR_NULL(), although today
it's always NULL for our case, true.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
