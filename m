Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab2JVNQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:16:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48161 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752334Ab2JVNQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:16:44 -0400
Message-ID: <1350911803.7502.4.camel@joe-AO722>
Subject: [PATCH] checkpatch: Warn on unnecessary line continuations
From: Joe Perches <joe@perches.com>
To: Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: David Howells <dhowells@redhat.com>, "Ken O'Brien" <kernel@kenobrien.org>,
        gregkh@linuxfoundation.org, swetland@google.com, arve@android.com,
        viro@zeniv.linux.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Oct 2012 06:16:43 -0700
In-Reply-To: <1350910971.28457.3.camel@thor>
References: <1350781512.16706.3.camel@joe-AO722>
	 <1350772400-12347-1-git-send-email-kernel@kenobrien.org>
	 <18159.1350898659@warthog.procyon.org.uk>
	 <1350908109.5931.28.camel@joe-AO722> <1350910971.28457.3.camel@thor>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Line continuations are not normal kernel style.
Bleat a warning when used outside of a macro definition.

Signed-off-by: Joe Perches <joe@perches.com>
---

On Mon, 2012-10-22 at 09:02 -0400, Peter Hurley wrote:
> On Mon, 2012-10-22 at 05:15 -0700, Joe Perches wrote:
> > waOn Mon, 2012-10-22 at 10:37 +0100, David Howells wrote:
> > > Joe Perches <joe@perches.com> wrote:
> > > 
> > > > On Sat, 2012-10-20 at 23:33 +0100, Ken O'Brien wrote:
> > > > ...
> > > > > -		pr_err("binder: %d: binder_alloc_buf failed to "
> > > > > +		pr_err("binder: %d: binder_alloc_buf failed to " \
> > > > >  		       "map pages in userspace, no vma\n", proc->pid);
> > > > ...
> > > > Nice try, but the "right" way to do this is to coalesce formats like:
> > > > 
> > > > 		pr_err("binder: %d: binder_alloc_buf failed to map pages in userspace, no vma\n",
> > > > 		       proc->pid);
> > > 
> > > Surely the right way is to fix _checkpatch_ to see ["]\n\s*["] and merge the
> > > lines before checking them?  We shouldn't have to fix up the source in either
> > > of these fashions just because checkpatch is broken.
> > 
> > checkpatch is stupid, but it's not broken here.
> > 
> > Formats should be coalesced into a single line to make
> > grepping the source for dmesg output easier.
> 
> But MODULE_PARM_DESC() multi-line strings are ok, right?
> 

I don't think so.
Maybe this patch:

 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 21a9f5d..d4ea29a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3011,6 +3011,14 @@ sub process {
 					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
 				}
 			}
+
+# check for line continuations outside of #defines
+
+		} else {
+			if ($line =~ /^\+.*\\$/) {
+				WARN("LINE_CONTINUATIONS",
+				     "Avoid unnecessary line continuations\n" . $herecurr);
+			}
 		}
 
 # do {} while (0) macro tests:


