Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab1EDVBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 17:01:11 -0400
Received: from mail.perches.com ([173.55.12.10]:1246 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab1EDVBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 17:01:08 -0400
Subject: Re: [PATCH 1/2] libertas: Convert lbs_pr_<level> to pr_<level>
From: Joe Perches <joe@perches.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1304537949.1097.8.camel@dcbw.foobar.com>
References: <cover.1304379925.git.joe@perches.com>
	 <353dfb1607172b5a3dbaccddbe52c24312d42af4.1304379925.git.joe@perches.com>
	 <1304537949.1097.8.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 14:01:06 -0700
Message-ID: <1304542866.1788.102.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 14:39 -0500, Dan Williams wrote:
> On Mon, 2011-05-02 at 16:49 -0700, Joe Perches wrote:
> > Use the standard pr_<level> functions eases grep a bit.
> > Added a few missing terminating newlines to messages.
> > Coalesced long formats.
> Is there any reason to not put the pr_fmt() definition into 'defs.h'
> instead of C&P at the top of every file?  I don't really care either way
> but that seems cleaner since almost all the libertas files are going to
> use logging.

It has to be before any #include <linux/kernel.h>
or any other #include that uses it.

At some point, all of the uses of

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

should be removed as I intend to have that
or an equivalent become the default.


