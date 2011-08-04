Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab1HDBPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 21:15:33 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60421 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753169Ab1HDBP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 21:15:26 -0400
Date: Wed, 3 Aug 2011 18:15:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH -next] efivars: fix build warning when PSTORE is not enabled
Message-Id: <20110803181524.6b7062d1.rdunlap@xenotime.net>
In-Reply-To: <20110804104927.be96accd4f255d2537d7372a@canb.auug.org.au>
References: <20110803151651.687fc6f377e255eccf58301b@canb.auug.org.au>
	<20110803104030.3c6443ab.rdunlap@xenotime.net>
	<20110804104927.be96accd4f255d2537d7372a@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Aug 2011 10:49:27 +1000 Stephen Rothwell wrote:

> Hi Randy,
> 
> On Wed, 3 Aug 2011 10:40:30 -0700 Randy Dunlap <rdunlap@xenotime.net> wrote:
> >
> > What is this warning about?  I don't see the problem.
> > 
> > The warning only happens on i386 AFAIK.  Must be some typedef glitch?
> > 
> > drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type
> 
> The second argument to the write method in a pstore_info is supposed to
> be "unsigned int" but the assigned function has "int" in the
> !CONFIG_PSTORE version.

Dang, I missed that second version of the write function.  Thanks.

---
From: Randy Dunlap <rdunlap@xenotime.net>

Fix efivars.c build warning when CONFIG_PSTORE is not enabled:

drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: matthew.e.tolentino@intel.com
---
 drivers/firmware/efivars.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20110803.orig/drivers/firmware/efivars.c
+++ linux-next-20110803/drivers/firmware/efivars.c
@@ -580,8 +580,8 @@ static ssize_t efi_pstore_read(u64 *id, 
 	return -1;
 }
 
-static u64 efi_pstore_write(enum pstore_type_id type, int part, size_t size,
-			    struct pstore_info *psi)
+static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
+			    size_t size, struct pstore_info *psi)
 {
 	return 0;
 }
