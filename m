Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1G3TFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:05:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61726 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1G3TFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:05:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110729180912.82054516.rdunlap@xenotime.net>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729180912.82054516.rdunlap@xenotime.net>
Date: Sat, 30 Jul 2011 15:05:45 -0400
Message-ID: <CAP=VYLq85O93Wa-_A98y6=CV1k-CwyqVxwXUqNVfhkUd9Oz1Cw@mail.gmail.com>
Subject: Re: [PATCH -next] sfi: sfi_acpi.c needs sysfs.h
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
        sfi-devel@simplefirmware.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 9:09 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> sfi_acpi.c needs to include linux/sysfs.h for data types.

Applied to module.h-split, thanks.

P.

>
> drivers/sfi/sfi_core.h:66: error: field 'attr' has incomplete type
> drivers/sfi/sfi_acpi.c:179: warning: 'struct kobject' declared inside parameter list
> drivers/sfi/sfi_acpi.c:179: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/sfi/sfi_acpi.c:182: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/sfi/sfi_acpi.c:182: warning: initialization from incompatible pointer type
>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/sfi/sfi_core.h |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- linux-next-20110729.orig/drivers/sfi/sfi_core.h
> +++ linux-next-20110729/drivers/sfi/sfi_core.h
> @@ -55,6 +55,9 @@
>   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>
>  */
> +
> +#include <linux/sysfs.h>
> +
>  struct sfi_table_key{
>        char    *sig;
>        char    *oem_id;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
