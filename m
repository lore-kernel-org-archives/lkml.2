Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab1EMOlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:41:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1EMOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:41:01 -0400
Subject: Re: [PATCH 01/16] fix default __strnlen_user macro
From: Mark Salter <msalter@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110513135501.GA747@localhost.ucw.cz>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
	 <1305144843-5058-2-git-send-email-msalter@redhat.com>
	 <20110513135501.GA747@localhost.ucw.cz>
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Fri, 13 May 2011 10:40:57 -0400
Message-Id: <1305297657.15167.130.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 13:55 +0000, Pavel Machek wrote:
> > The existing __strnlen_user macro simply resolved to strnlen. However, the
> > count returned by strnlen_user should include the NULL byte. This patch
> > fixes the __strnlen_user macro to include the NULL byte in the count.
> 
> Are you sure? Having strnlen and _foo_strnlen with different return
> values seems very very dangerous.
> 

Yes. I am sure based on comments and usage elsewhere in the kernel.
That difference certainly through me off track as I tried to figure out
why my kernels failed to mount roots when I switched to the generic
uaccess.h.

--Mark


