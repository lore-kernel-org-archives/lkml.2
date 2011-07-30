Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1G3BJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 21:09:16 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:46631 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752840Ab1G3BJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 21:09:14 -0400
Date: Fri, 29 Jul 2011 18:09:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
        sfi-devel@simplefirmware.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] sfi: sfi_acpi.c needs sysfs.h
Message-Id: <20110729180912.82054516.rdunlap@xenotime.net>
In-Reply-To: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

sfi_acpi.c needs to include linux/sysfs.h for data types.

drivers/sfi/sfi_core.h:66: error: field 'attr' has incomplete type
drivers/sfi/sfi_acpi.c:179: warning: 'struct kobject' declared inside parameter list
drivers/sfi/sfi_acpi.c:179: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/sfi/sfi_acpi.c:182: warning: type defaults to 'int' in declaration of '__mptr'
drivers/sfi/sfi_acpi.c:182: warning: initialization from incompatible pointer type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/sfi/sfi_core.h |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20110729.orig/drivers/sfi/sfi_core.h
+++ linux-next-20110729/drivers/sfi/sfi_core.h
@@ -55,6 +55,9 @@
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */
+
+#include <linux/sysfs.h>
+
 struct sfi_table_key{
 	char	*sig;
 	char	*oem_id;
