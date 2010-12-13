Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab0LMGdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 01:33:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:24236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0LMGdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 01:33:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,334,1288594800"; 
   d="scan'208";a="360750177"
From: "Brown, Len" <len.brown@intel.com>
To: Andi Kleen <andi@firstfloor.org>, "davej@redhat.com" <davej@redhat.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Sun, 12 Dec 2010 23:33:02 -0700
Subject: RE: [PATCH] [167/223] ACPI: debugfs custom_method open to non-root
Thread-Topic: [PATCH] [167/223] ACPI: debugfs custom_method open to non-root
Thread-Index: AcuaVv7ueJfevDlOSnCgiyOLxOJ/gQAOFvCQ
Message-ID: <E87738D94A6AD54789B5B8D1BAEB06CC700C2347FF@azsmsx503.amr.corp.intel.com>
References: <201012131244.547034648@firstfloor.org>
 <20101212234751.76302B27BF@basil.firstfloor.org>
In-Reply-To: <20101212234751.76302B27BF@basil.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.

is -longterm something that happens after -stable runs out of gas?
Note that this particular patch applies back to 2.6.33.

thanks,
-Len

> ------------------
> From: Dave Jones <davej@redhat.com>
> 
> commit ed3aada1bf34c5a9e98af167f125f8a740fc726a upstream.
> 
> Currently we have:
> 
>   --w--w--w-. 1 root root 0 2010-11-11 14:56 /sys/kernel/debug/acpi/custom_method
> 
> which is just crazy. Change this to --w-------.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  drivers/acpi/debug.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/acpi/debug.c
> ===================================================================
> --- linux.orig/drivers/acpi/debug.c
> +++ linux/drivers/acpi/debug.c
> @@ -258,7 +258,7 @@ static int acpi_debugfs_init(void)
>  	if (!acpi_dir)
>  		goto err;
> 
> -	cm_dentry = debugfs_create_file("custom_method", S_IWUGO,
> +	cm_dentry = debugfs_create_file("custom_method", S_IWUSR,
>  					acpi_dir, NULL, &cm_fops);
>  	if (!cm_dentry)
>  		goto err;
