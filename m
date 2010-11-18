Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909Ab0KRXpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 18:45:49 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53404 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0KRXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 18:45:49 -0500
Date: Thu, 18 Nov 2010 15:45:27 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: dann frazier <dann.frazier@canonical.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] [OCFS2] ocfs2_connection_find() returns
 pointer to bad structure
Message-ID: <20101118234527.GL19821@mail.oracle.com>
Mail-Followup-To: dann frazier <dann.frazier@canonical.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <1290117789-3915-1-git-send-email-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290117789-3915-1-git-send-email-dann.frazier@canonical.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 03:03:09PM -0700, dann frazier wrote:
> If ocfs2_live_connection_list is empty, ocfs2_connection_find() will return
> a pointer to the LIST_HEAD, cast as a ocfs2_live_connection. This can cause
> an oops when ocfs2_control_send_down() dereferences c->oc_conn:
> 
> Call Trace:
>   [<ffffffffa00c2a3c>] ocfs2_control_message+0x28c/0x2b0 [ocfs2_stack_user]
>   [<ffffffffa00c2a95>] ocfs2_control_write+0x35/0xb0 [ocfs2_stack_user]
>   [<ffffffff81143a88>] vfs_write+0xb8/0x1a0
>   [<ffffffff8155cc13>] ? do_page_fault+0x153/0x3b0
>   [<ffffffff811442f1>] sys_write+0x51/0x80
>   [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b
> 
> Fix by explicitly returning NULL if no match is found.
> 
> Signed-off-by: dann frazier <dann.frazier@canonical.com>

	This patch is now in the fixes branch of ocfs2.git.

Joel

-- 

"I don't even butter my bread; I consider that cooking."
         - Katherine Cebrian

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
