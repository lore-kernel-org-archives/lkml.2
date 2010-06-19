Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0FSH1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 03:27:52 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48255 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab0FSH1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 03:27:50 -0400
Date: Sat, 19 Jun 2010 09:27:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de, hpa@linux.intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86, vdso: Error out if the vdso contains
 external references
Message-ID: <20100619072745.GA18946@basil.fritz.box>
References: <tip-*@vger.kernel.org>
 <tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-05d0b0889ca9d033a960542af7f8a13b3ad4f630@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
> new file mode 100755
> index 0000000..490be1c
> --- /dev/null
> +++ b/arch/x86/vdso/checkundef.sh
> @@ -0,0 +1,10 @@
> +#!/bin/sh
> +nm="$1"
> +file="$2"
> +"$nm" "$file" | grep '^ *U' > /dev/null 2>&1

Does that really handle the failed inline, static function case? 

In this case you get a function which is not 'U', but it's 
just in the wrong section. I think that would need to be checked too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
