Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab1C3Byn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 21:54:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64993 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab1C3Bym convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 21:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G0EzpLKCkUmNpUK5v4fgshqx1VEhPium3H+HdZjGsX87U2dADFzimrs53javUG7naQ
         Xi57+ZCH2FEv+//Ru/o1VVsuBDxliXU+0bE8YQ7837Gwp4WkVee3z5XVqIi0hqPAufiQ
         qVQn0r0YHdTmqxvgdjJ6064JNwpQOV5BqtD5Q=
MIME-Version: 1.0
In-Reply-To: <f4fbd2191533fd96fa59ba19c9917ed679920e1b.1301436234.git.joe@perches.com>
References: <cover.1301436234.git.joe@perches.com> <f4fbd2191533fd96fa59ba19c9917ed679920e1b.1301436234.git.joe@perches.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 29 Mar 2011 22:54:21 -0300
Message-ID: <AANLkTikWbHSPaCTStEz5v=gEvm-nG6MU2eSCq9G8eZtD@mail.gmail.com>
Subject: Re: [PATCH 09/23] hdaps: Convert printks to pr_<level>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>, Frank Seidel <frank@f-seidel.de>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 19:21, Joe Perches <joe@perches.com> wrote:
> Added pr_fmt, converted printks and removed
> hard coded prefixes.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/hdaps.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
> index 067bf36..5a34973 100644
> --- a/drivers/platform/x86/hdaps.c
> +++ b/drivers/platform/x86/hdaps.c
> @@ -26,6 +26,8 @@
>  * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
>  */
>
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/delay.h>
>  #include <linux/platform_device.h>
>  #include <linux/input-polldev.h>
> @@ -238,7 +240,7 @@ static int hdaps_device_init(void)
>                     __check_latch(0x1611, 0x01))
>                goto out;
>
> -       printk(KERN_DEBUG "hdaps: initial latch check good (0x%02x).\n",
> +       printk(KERN_DEBUG "hdaps: initial latch check good (0x%02x)\n",

Shouldn't this be pr_debug() or pr_devel() ?



Lucas De Marchi
