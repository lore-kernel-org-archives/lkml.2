Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2CLRLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:11:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33325 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753185Ab2CLRLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:11:11 -0400
Message-ID: <1331572270.13200.30.camel@joe2Laptop>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Joe Perches <joe@perches.com>
To: dedekind1@gmail.com
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Mar 2012 10:11:10 -0700
In-Reply-To: <1331570150.12037.55.camel@sauron.fi.intel.com>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
	 <1331318968.13055.8.camel@joe2Laptop>
	 <1331557935.12037.11.camel@sauron.fi.intel.com>
	 <1331566415.13200.14.camel@joe2Laptop>
	 <1331570150.12037.55.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 18:35 +0200, Artem Bityutskiy wrote:
> On Mon, 2012-03-12 at 08:33 -0700, Joe Perches wrote:
> > I tentatively converted them to a bitmap
> > and a single jffs2_dbg(mask, fmt, ...)
> > but perhaps all of these could be deleted
> > too.
> 
> I think it is better to convert them to jffs2_debug(). And I guess after
> the change the "mask" parameter will go away?

Mask would remain and perhaps become a module
variable instead of a compile #define.

What is jffs2_debug?  Do you mean JFFS2_DEBUG?
My intent was to remove JFFS2_<LEVEL> defines and uses.
These #defines add
	"(%d) %s" ... task_pid_nr(current), __func__
which can be added if really necessary via pr_fmt
to generic pr_<level> uses.

I am not certain of the value for generic uses of
task_pid_nr in pr_notice,pr_err, or pr_info.

Dynamic debugging has the ability to optionally add
task_pid_vnr and __func__ to pr_debug output.


