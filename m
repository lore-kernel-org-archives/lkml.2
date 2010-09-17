Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IQQby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 12:31:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab0IQQbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 12:31:53 -0400
Date: Fri, 17 Sep 2010 09:21:42 -0700
From: Greg KH <gregkh@suse.de>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: Make CFLAGS explicit
Message-ID: <20100917162142.GA30385@suse.de>
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 09:20:10AM -0600, Tim Gardner wrote:
> Its too easy to confuse the obscurely named WLC_LOW/WLC_HIGH CFLAG
> macros.

True, but doesn't this change how the code is being built?  Why make
this change?

> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Henry Ptasinski <henryp@broadcom.com>
> Cc: Nohee Ko <noheek@broadcom.com>
> ---
>  drivers/staging/brcm80211/Makefile |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
> index 05a4103..7a77e7f 100644
> --- a/drivers/staging/brcm80211/Makefile
> +++ b/drivers/staging/brcm80211/Makefile
> @@ -15,8 +15,9 @@
>  # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>  # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>  
> -EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
> +EXTRA_CFLAGS := -DBCMDBG -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes

how about 2 patches here, one to break it out into one flag per line so
we can see what is really happening here, and then one patch to make the
change you are asking for.

>  
> +USB_CFLAGS := -DWLC_HIGH

Are you sure about this?  Why set this when I don't see anything ever
using it?

What problem are you trying to fix here.

totally confused,

greg k-h
