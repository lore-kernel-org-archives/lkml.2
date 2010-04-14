Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0DNDCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 23:02:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43115 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0DNDCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:02:05 -0400
MIME-Version: 1.0
In-Reply-To: <20100414024842.GB3718@localhost.localdomain>
References: <20100414024842.GB3718@localhost.localdomain>
Date: Tue, 13 Apr 2010 23:02:02 -0400
Message-ID: <j2z7e0fb38c1004132002sba54d278xc0337bed6e09dec5@mail.gmail.com>
Subject: Re: Security: Replace dac_mmap_min_addr to mmap_min_addr in 
	cap_file_mmap()
From: Eric Paris <eparis@parisplace.org>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK NAK NAK

go back and reread the whole purpose for the separation.

-Eric

On Tue, Apr 13, 2010 at 10:48 PM,  <wzt.wzt@gmail.com> wrote:
> cap_file_mmap() comments said "If the process is attempting to map
> memory below mmap_min_addr", if CONFIG_LSM_MMAP_MIN_ADDR is set,
> dac_mmap_min_addr is not equal mmap_min_addr, so replace dac_mmap_min_addr
> to mmap_min_addr seems to be better.
>
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>
> ---
>  include/linux/security.h |    1 +
>  security/commoncap.c     |    2 +-
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 233d20b..61fd9e7 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -101,6 +101,7 @@ void reset_security_ops(void);
>  extern unsigned long mmap_min_addr;
>  extern unsigned long dac_mmap_min_addr;
>  #else
> +#define mmap_min_addr          0UL
>  #define dac_mmap_min_addr      0UL
>  #endif
>
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 6166973..878cf89 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -942,7 +942,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
>  {
>        int ret = 0;
>
> -       if (addr < dac_mmap_min_addr) {
> +       if (addr < mmap_min_addr) {
>                ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
>                                  SECURITY_CAP_AUDIT);
>                /* set PF_SUPERPRIV if it turns out we allow the low mmap */
> --
> 1.6.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
