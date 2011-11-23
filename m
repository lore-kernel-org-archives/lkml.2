Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab1KWBfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:35:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41166 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759044Ab1KWBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:35:07 -0500
Date: Tue, 22 Nov 2011 17:35:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: David Daney <ddaney.cavm@gmail.com>
cc: ralf@linux-mips.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, DM <dm.n9107@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 2/2] hugetlb: Replace BUG() with BUILD_BUG() for dummy
 definitions.
In-Reply-To: <1321985686-798-3-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <alpine.DEB.2.00.1111221734310.18644@chino.kir.corp.google.com>
References: <1321985686-798-1-git-send-email-ddaney.cavm@gmail.com> <1321985686-798-3-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> The file linux/hugetlb.h has many places where dummy symbols were
> defined so that the main source code would contain fewer:
> 
>     #ifdef CONFIG_HUGETLBFS
> 
> or
> 
>     #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> 
> If there were any misuse of these symbols, the only symptom would be
> an OOPS at runtime.  Change the BUG() to BUILD_BUG() to catch
> any such abuse at compile time instead.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: David Rientjes <rientjes@google.com>

> @@ -186,7 +186,7 @@ static inline void set_file_hugepages(struct file *file)
>  #else /* !CONFIG_HUGETLBFS */
>  
>  #define is_file_hugepages(file)			0
> -#define set_file_hugepages(file)		BUG()
> +#define set_file_hugepages(file)		BUILD_BUG()
>  static inline struct file *hugetlb_file_setup(const char *name, size_t size,
>  		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
>  {

Looks like this symbol can just be removed entirely, it's not referenced 
anywhere.
