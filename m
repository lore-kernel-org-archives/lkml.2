Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab2IGJEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:04:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51517 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2IGJEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:04:12 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC]fs: fsprivate data argument for get_block_t
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Fri, 07 Sep 2012 13:04:08 +0400
Message-ID: <87r4qejjav.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm wonder why generic get_block_t callback has not fsprivate
argument?
Each filesystem implement it's own get_block_t callback.
Each filesystem call generic functions which use callback from
known context, but where is no good way to pass that context 
to fs_specific_get_block callback.
This result in situation where fs-specific data passed via 
inode's data (xxx_inode->cur_get_block_data)
All this means that inode's private pointer becomes implicit
serialization point even if get_block() are allowed to be called
concurrently.

I'm going to add fsprivate argument, number of generic function which
use get_block_t is not really huge, so the patch should be too big.

If some one has any objections why this shouldn't be done, please
welcome. 


