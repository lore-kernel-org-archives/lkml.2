Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1GUMu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:50:59 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41486 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1GUMu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:50:57 -0400
Date: Thu, 21 Jul 2011 16:50:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] taskstats: add_del_listener() should ignore !valid
 listener's
Message-ID: <20110721125051.GA5443@albatros>
References: <20110720185959.GA21749@redhat.com>
 <20110720190036.GB21753@redhat.com>
 <20110720194603.GA3385@albatros>
 <20110720210146.GA6273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720210146.GA6273@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 23:01 +0200, Oleg Nesterov wrote:
> > it is unknown when it died.  As the same pid
> > can be reused by a new process BEFORE add_del_listener(), it is unknown
> > whether ->pid points to the actual owner task.
> 
> And? Why should we try to reuse the !valid entries? struct listener
> is just the "addr" we should send the message to. If someone calls
> add_listener() it should works regardless of dead entries with the
> same ->pid.

True.

> > Rather than optimizing the wrong algorithm it's better to change the
> > processes keeping way.
> 
> Not sure I understand... This is not optimizing, the patch tries to
> fix the unlikely (in fact mostly theoretical) and minor problem.

Ah, I see the problem here.  Yes, then it surely makes sense.

Reviewed-by: Vasiliy Kulikov <segoon@openwall.com>


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
