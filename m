Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2CXHHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 03:07:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2CXHHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 03:07:31 -0400
Date: Sat, 24 Mar 2012 00:10:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Chen Gong (gong.chen@linux.intel.com)" <gong.chen@linux.intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [Patch]Introduce get_reason_str() to pstore
Message-Id: <20120324001054.4eb82767.akpm@linux-foundation.org>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2E32064CDF@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2E32064CDF@USINDEVS01.corp.hds.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 13:01:49 -0400 Seiji Aguchi <seiji.aguchi@hds.com> wrote:

> Hi,
> 
> Recently, there has been some changes in kmsg_dump() below and they have been applied to linus-tree. 
>  (1) kmsg_dump(KMSG_DUMP_KEXEC) was removed.
>      http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a3dd3323058d281abd584b15ad4c5b65064d7a61
> 
>  (2) A order of "enum kmsg_dump_reason" was modified.
>      http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=c22ab332902333f83766017478c1ef6607ace681
> 
>  This patch removes reason_str array and add get_reason_str() in accordance with Adrian's comment below.
>  https://lkml.org/lkml/2012/3/16/63
> 
>  Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>  Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> ---
>  fs/pstore/platform.c |   30 ++++++++++++++++++++++--------
>  1 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 9ec22d3..82c585f 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -68,9 +68,25 @@ void pstore_set_kmsg_bytes(int bytes)
>  /* Tag each group of saved records with a sequence number */
>  static int	oopscount;
>  
> -static char *reason_str[] = {
> -	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
> -};
> +static const char *get_reason_str(enum kmsg_dump_reason reason) {
> +	switch (reason) {
> +	case KMSG_DUMP_PANIC:
> +		return "Panic";
> +	case KMSG_DUMP_OOPS:
> +		return "Oops";
> +	case KMSG_DUMP_EMERG:
> +		return "Emergency";
> +	case KMSG_DUMP_RESTART:
> +		return "Restart";
> +	case KMSG_DUMP_HALT:
> +		return "Halt";
> +	case KMSG_DUMP_POWEROFF:
> +		return "Poweroff";
> +	default:
> +		return "Unknown";
> +	}
> +}

Better:

static char *reason_str[] = {
	[KMSG_DUMP_OOPS] = "Oops",
	[KMSG_DUMP_PANIC] = "Panic",
	...
	[KMSG_DUMP_POWEROFF] = "Poweroff",
};

