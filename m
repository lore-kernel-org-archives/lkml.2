Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1F2Ink (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:43:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39035 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab1F2Ind (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:43:33 -0400
Date: Wed, 29 Jun 2011 10:43:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: workqueue question.
Message-ID: <20110629084329.GI3386@htj.dyndns.org>
References: <4E0A23E7.1000606@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0A23E7.1000606@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 28, 2011 at 11:56:39AM -0700, Ben Greear wrote:
> Is it OK to call INIT_WORK(&foo, bar)
> if we are currently being called by the work-queue
> using foo?

Yes, but if flush_work*() races with it, flushing can finish before
execution is complete.

> Also, is it valid to free the memory containing foo
> in a workqueue callback?

Yeap.

-- 
tejun
