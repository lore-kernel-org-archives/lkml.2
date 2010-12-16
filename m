Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0LPR0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:26:03 -0500
Received: from mail.perches.com ([173.55.12.10]:2709 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab0LPR0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:26:00 -0500
Subject: [PATCH] checkpatch.pl: Add "prefer __packed" check
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101216152121.GB2413@tuxdriver.com>
References: <1292510088-7449-1-git-send-email-linville@tuxdriver.com>
	 <4D0A2AA8.5060808@lwfinger.net>  <20101216152121.GB2413@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 09:25:58 -0800
Message-ID: <1292520358.29894.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a __packed #define for this __attribute__((packed)).
Might as well get checkpatch to tell people about it.

Signed-off-by: Joe Perches <joe@perches.com>

---

On Thu, 2010-12-16 at 10:21 -0500, John W. Linville wrote:
> On Thu, Dec 16, 2010 at 09:05:12AM -0600, Larry Finger wrote:
> > On 12/16/2010 08:34 AM, John W. Linville wrote:
> > > Use "__packed" instead of "__attribute__ ((packed))"...
> > As a point of interest, is this the "new" recommended way? The reason I ask is
> > that the Linux headers are mostly in the attribute form.
> AIUI, "__packed" is the one true way.  I think this facilitates
> compiling the kernel with compilers other than GCC.
> 
> At any rate, Dave Miller threatened to injure me if I kept sending him stuff using 
> "__attribute__ ((packed))"... :-)

 scripts/checkpatch.pl |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e3c7fc0..6fc24af 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2743,6 +2743,11 @@ sub process {
 			WARN("plain inline is preferred over $1\n" . $herecurr);
 		}
 
+# Check for __attribute__ packed, prefer __packed
+		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
+			WARN("__packed is preferred over __attribute__((packed))\n" . $herecurr);
+		}
+
 # check for sizeof(&)
 		if ($line =~ /\bsizeof\s*\(\s*\&/) {
 			WARN("sizeof(& should be avoided\n" . $herecurr);



