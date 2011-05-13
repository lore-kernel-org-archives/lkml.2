Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab1EMNzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:55:20 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:45222 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751399Ab1EMNzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:55:18 -0400
Date: Fri, 13 May 2011 13:55:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/16] fix default __strnlen_user macro
Message-ID: <20110513135501.GA747@localhost.ucw.cz>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com> <1305144843-5058-2-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305144843-5058-2-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The existing __strnlen_user macro simply resolved to strnlen. However, the
> count returned by strnlen_user should include the NULL byte. This patch
> fixes the __strnlen_user macro to include the NULL byte in the count.

Are you sure? Having strnlen and _foo_strnlen with different return
values seems very very dangerous.

> @@ -289,7 +289,7 @@ strncpy_from_user(char *dst, const char __user *src, long count)
>   * Return 0 on exception, a value greater than N if too long
>   */
>  #ifndef __strnlen_user
> -#define __strnlen_user strnlen
> +#define __strnlen_user(s, n) (strnlen((s), (n)) + 1)
>  #endif
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
