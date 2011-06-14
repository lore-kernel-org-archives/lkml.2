Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1FNHRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:17:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33634 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab1FNHRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lETiFeqSyNC/yNKgkEL9o0wmPHKP0OQYxhLUnWbaBVTpA8ceQc+Bj5rAO3parwQLpE
         7cOKhgr6IuVUmJY73aSOjSb2QjnzG95cBnU86m5Vii3fa6vlSkoZSbu/Uj3Y3jTIa5U4
         MtW43++fCCm6uLIx4TvhbhjAnbCOcD/nH2dl8=
Date: Tue, 14 Jun 2011 09:15:40 +0200
From: Tejun Heo <tj@kernel.org>
To: Maxin B John <maxin.john@gmail.com>
Cc: akpm@linux-foundation.org, segooon@gmail.com, jkosina@suse.cz,
        tglx@linutronix.de, eike-kernel@sf-tec.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
Message-ID: <20110614071540.GE8141@htj.dyndns.org>
References: <20110614070732.GA3355@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614070732.GA3355@maxin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 14, 2011 at 10:07:32AM +0300, Maxin B John wrote:
> A freed pointer is passed as an argument to the function "devres_destroy()" in
> "kernel/irq/devres.c" and "lib/devres.c". This patch fixes the possible use 
> after free.
> 
> It's notabug at this time, but the code is dangerous.

The code is not dangerous.  The pointer value is used strictly as key
and the code path is always properly serialized.  The change is to
appease access-after-free detection logic, similar to the way we
change the code to better accomodate sparse or other code analysys
tools.  Can you please update the patch description to reflect that?

Thank you.

-- 
tejun
