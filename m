Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab1IICNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 22:13:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41615 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932515Ab1IICNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 22:13:17 -0400
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct
 _ddebug descriptor definitions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        bvanassche@acm.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Sep 2011 19:13:16 -0700
In-Reply-To: <20110908165230.a7505321.akpm@linux-foundation.org>
References: <cover.1314725877.git.jbaron@redhat.com>
	 <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
	 <20110908165230.a7505321.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.91- 
Content-Transfer-Encoding: 7bit
Message-ID: <1315534396.11939.10.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 16:52 -0700, Andrew Morton wrote:
> On Tue, 30 Aug 2011 14:28:41 -0400
> Jason Baron <jbaron@redhat.com> wrote:
> > Replace the repetitive struct _ddebug descriptor definitions with
> > a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
> > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> > +	static struct _ddebug __used __aligned(8)		\
> > +	__attribute__((section("__verbose"))) name = {		\
> > +		.modname = KBUILD_MODNAME,			\
> > +		.function = __func__,				\
> > +		.filename = __FILE__,				\
> > +		.format = (fmt),				\
> > +		.lineno = __LINE__,				\
> > +		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
> > +		.enabled = false,				\
> > +	}
> <anal>That macro implements a definition, not a declaration</anal>

Andrew, that's not quite true and that's how
DECLARE is normally used in linux.

DECLARE_BITMAP, DECLARE_COMPLETION, DECLARE_RWSEM, etc.

A lot of the DEFINE_FOO(name) macros use ##name.


