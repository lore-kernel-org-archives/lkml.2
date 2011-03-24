Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934325Ab1CXWtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:49:09 -0400
Received: from mail.perches.com ([173.55.12.10]:4267 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756567Ab1CXWtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:49:07 -0400
Subject: Re: [PATCH 0/2] Fix resource size miscalculations
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-fbdev@vger.kernel.org
In-Reply-To: <cover.1300909445.git.joe@perches.com>
References: <cover.1300909445.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 15:49:05 -0700
Message-ID: <1301006945.29444.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 12:55 -0700, Joe Perches wrote:
> Use resource_size a few places

Perhaps this relatively common error is too common.
It seems to be poor style.  A possible better style for
struct resource uses could be inline function(s) like:

static inline void __iomem *resource_ioremap(struct resource *r)
{
	return ioremap(r->start, resource_size(r));
}

and maybe

static inline struct resource *
resource_request_region(struct resource *r, const char *name)
{
	return __request_region(&ioport_resource, r->start, resource_size(r), name, 0);
}


