Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539Ab2IYVaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:30:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2IYV3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:29:49 -0400
Date: Tue, 25 Sep 2012 14:29:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 05/10] mm, util: Use dup_user to duplicate user memory
Message-Id: <20120925142948.6b062cb6.akpm@linux-foundation.org>
In-Reply-To: <1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<1347137279-17568-5-git-send-email-elezegarcia@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Sep 2012 17:47:54 -0300
Ezequiel Garcia <elezegarcia@gmail.com> wrote:

> Previously the strndup_user allocation was being done through memdup_user,
> and the caller was wrongly traced as being strndup_user
> (the correct trace must report the caller of strndup_user).
> 
> This is a common problem: in order to get accurate callsite tracing,
> a utils function can't allocate through another utils function,
> but instead do the allocation himself (or inlined).
> 
> Here we fix this by creating an always inlined dup_user() function to
> performed the real allocation and to be used by memdup_user and strndup_user.

This patch increases util.o's text size by 238 bytes.  A larger kernel
with a worsened cache footprint.

And we did this to get marginally improved tracing output?  This sounds
like a bad tradeoff to me.

