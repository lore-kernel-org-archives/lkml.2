Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab1GTTqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:46:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62060 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab1GTTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:46:10 -0400
Date: Wed, 20 Jul 2011 23:46:03 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] taskstats: add_del_listener() should ignore !valid
 listener's
Message-ID: <20110720194603.GA3385@albatros>
References: <20110720185959.GA21749@redhat.com>
 <20110720190036.GB21753@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720190036.GB21753@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 21:00 +0200, Oleg Nesterov wrote:
> When send_cpu_listeners() finds the orphaned listener it marks
> it as !valid and drops listeners->sem. Before it takes this sem
> for wrinting, s->pid can be reused and add_del_listener() can
> wrongly try to re-use this entry.
> 
> Change add_del_listener() to check ->valid = T.

I think the current logic is wrong.  If s was claimed is invalid, it
then points to a dead task, it is unknown when it died.  As the same pid
can be reused by a new process BEFORE add_del_listener(), it is unknown
whether ->pid points to the actual owner task.

Rather than optimizing the wrong algorithm it's better to change the
processes keeping way.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
