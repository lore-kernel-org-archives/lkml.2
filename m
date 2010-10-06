Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab0JFAcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 20:32:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59132 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434Ab0JFAca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 20:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SeA3u+WkqC6qPkHHlG8+Na5ktFrNqkCaBIm38b8dX2k06iXp5KMDI1CKqDqsgb+Y/t
         2zGNvAEtpnhLamMGzwBlCqxyzdC64nO/er5OIwQqI5+jgNpt3OERi1XFzKYakAj2N/ra
         7ZGFZ6W5dnOBqVmh1KUMhqRn+EI2E//q5Xdos=
MIME-Version: 1.0
In-Reply-To: <1286175485-30643-11-git-send-email-gthelen@google.com>
References: <1286175485-30643-1-git-send-email-gthelen@google.com>
	<1286175485-30643-11-git-send-email-gthelen@google.com>
Date: Wed, 6 Oct 2010 09:32:29 +0900
Message-ID: <AANLkTin0ymtTBbqpmcpCT835n8XWTJfaJKeU=CAj-=ej@mail.gmail.com>
Subject: Re: [PATCH 10/10] memcg: check memcg dirty limits in page writeback
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 3:58 PM, Greg Thelen <gthelen@google.com> wrote:
> If the current process is in a non-root memcg, then
> global_dirty_limits() will consider the memcg dirty limit.
> This allows different cgroups to have distinct dirty limits
> which trigger direct and background writeback at different
> levels.
>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  mm/page-writeback.c |   87 ++++++++++++++++++++++++++++++++++++++++++---------
>  1 files changed, 72 insertions(+), 15 deletions(-)
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index a0bb3e2..c1db336 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -180,7 +180,7 @@ static unsigned long highmem_dirtyable_memory(unsigned long total)
>  * Returns the numebr of pages that can currently be freed and used
>  * by the kernel for direct mappings.
>  */
> -static unsigned long determine_dirtyable_memory(void)
> +static unsigned long get_global_dirtyable_memory(void)
>  {
>        unsigned long x;
>
> @@ -192,6 +192,58 @@ static unsigned long determine_dirtyable_memory(void)
>        return x + 1;   /* Ensure that we never return 0 */
>  }
>

Just a nitpick.
You seem to like get_xxxx name.
But I think it's a redundant and just makes function name longer
without any benefit.
In kernel, many place doesn't use get_xxx naming.

-- 
Kind regards,
Minchan Kim
