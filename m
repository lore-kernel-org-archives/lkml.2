Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2H3WDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:03:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2H3WDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:03:49 -0400
Date: Thu, 30 Aug 2012 15:03:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paul.clements@steeleye.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [RESEND] add discard support to nbd
Message-Id: <20120830150348.287bfa2f.akpm@linux-foundation.org>
In-Reply-To: <503e0dde.ssYktQsJ5nYlhlQB%paul.clements@steeleye.com>
References: <503e0dde.ssYktQsJ5nYlhlQB%paul.clements@steeleye.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2012 08:41:02 -0400
paul.clements@steeleye.com wrote:

> Description: This patch adds discard support to nbd. When the nbd client
> system receives a discard request, this will be passed along to the nbd
> server system, where the nbd-server will respond by performing:
> 	fallocate(.. FALLOC_FL_PUNCH_HOLE ..)
> 
> To punch a hole in the backend storage, which is no longer needed.
> 

What happens if the user is running an older server?

I is it possible that because the old server didn't set
NBD_FLAG_SEND_TRIM, the user's screen gets filled with WARN_ONs?

Anyway, please make sure this combination was tested!


