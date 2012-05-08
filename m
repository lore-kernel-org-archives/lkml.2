Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab2EHXCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:02:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63448 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2EHXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:02:16 -0400
Date: Tue, 8 May 2012 16:02:12 -0700
From: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] driver core: check start node in klist_iter_init_node
Message-ID: <20120508230211.GA14839@kroah.com>
References: <1336458502-34402-1-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336458502-34402-1-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 08:28:22AM +0200, Hannes Reinecke wrote:
> klist_iter_init_node() takes a node as a start argument.
> However, this node might not be valid anymore.
> This patch updates the klist_iter_init_node() and
> dependent functions to return an error if so.
> All calling functions have been audited to check
> for a return code here.

Still breaks the build:

lib/klist.c: In function ‘klist_iter_init_node’:
lib/klist.c:287:9: error: ‘struct klist_node’ has no member named ‘klist’
make[1]: *** [lib/klist.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [lib] Error 2
make: *** Waiting for unfinished jobs....

