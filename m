Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732Ab1IIKcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 06:32:11 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45987 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab1IIKcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 06:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <1315540963.11939.12.camel@Joe-Laptop>
References: <cover.1314725877.git.jbaron@redhat.com> <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
 <20110908165230.a7505321.akpm@linux-foundation.org> <1315534396.11939.10.camel@Joe-Laptop>
 <20110908204200.6cf7abc2.akpm@linux-foundation.org> <1315540963.11939.12.camel@Joe-Laptop>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 9 Sep 2011 12:31:49 +0200
X-Google-Sender-Auth: zj3IO0gv60AozDLX4xYuz2fKamQ
Message-ID: <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Baron <jbaron@redhat.com>,
        gregkh@suse.de, jim.cromie@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 9, 2011 at 6:02 AM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2011-09-08 at 20:42 -0700, Andrew Morton wrote:
> > On Thu, 08 Sep 2011 19:13:16 -0700 Joe Perches <joe@perches.com> wrote:
> > > On Thu, 2011-09-08 at 16:52 -0700, Andrew Morton wrote:
> > > > On Tue, 30 Aug 2011 14:28:41 -0400
> > > > Jason Baron <jbaron@redhat.com> wrote:
> > > > > Replace the repetitive struct _ddebug descriptor definitions with
> > > > > a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.
> > > > > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)              \
> > > > > +       static struct _ddebug __used __aligned(8)               \
> > > > > +       __attribute__((section("__verbose"))) name = {          \
> > > > > +               .modname = KBUILD_MODNAME,                      \
> > > > > +               .function = __func__,                           \
> > > > > +               .filename = __FILE__,                           \
> > > > > +               .format = (fmt),                                \
> > > > > +               .lineno = __LINE__,                             \
> > > > > +               .flags =  _DPRINTK_FLAGS_DEFAULT,               \
> > > > > +               .enabled = false,                               \
> > > > > +       }
> > > > <anal>That macro implements a definition, not a declaration</anal>
> > > Andrew, that's not quite true
> > It's precisely true.
> Not according to the c99 standard section 6.7

Have you read that paragraph ? This is what I found in paragraph 6.7,
which confirms Andrews interpretation:

<quote>
A declaration speciﬁes the interpretation and attributes of a set of
identiﬁers. A deﬁnition of an identiﬁer is a declaration for that
identiﬁer that:
- for an object, causes storage to be reserved for that object;
- for a function, includes the function body;
- for an enumeration constant or typedef name, is the (only)
declaration of the identiﬁer.
</quote>

Bart.
