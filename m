Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2LLJmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 04:42:43 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:42129 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2LLJml convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 12 Dec 2012 04:42:41 -0500
Message-Id: <50C85F9F02000078000AFD6E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Wed, 12 Dec 2012 09:42:39 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Olaf Hering" <olaf@aepfle.de>, <konrad.wilk@oracle.com>
Cc: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/blkback: prevent repeated backend_changed
 invocations
References: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1355259026-16946-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.12.12 at 21:50, Olaf Hering <olaf@aepfle.de> wrote:
> backend_changed might be called multiple times, which will leak
> be->mode. Make sure it will be called only once. Remove some unneeded
> checks. Also the be->mode string was leaked, release the memory on
> device shutdown.

So did I miss some discussion here? I haven't seen any
confirmation of this function indeed being supposed to be called
just once.

Also, as said previously, if indeed it is to be called just once,
removing the watch during/after the first invocation would seem
to be the more appropriate thing to do.

Jan

