Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1ESBHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 21:07:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48656 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1ESBHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 21:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s8IDSoNcu6AVRtA9Z3j4JBDB3QB4py2HesRKBBfFGec/BG08RPJgvacCTzaq4Wsawm
         xi+BGi6z3TC5thwCI1xIlI7zVq8gOIcS2uSGZDKK4BqHyuws9R9mCmLGyl7vGmWpZED9
         ZFgN01titekPBPYVVf3RbC09zmJfULMZSqC5o=
Date: Thu, 19 May 2011 03:07:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [RFC PATCH] perf: Split up buffer handling from core code
Message-ID: <20110519010744.GC1723@nowhere>
References: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305767185-5771-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Borislav in Cc)

On Thu, May 19, 2011 at 03:06:25AM +0200, Frederic Weisbecker wrote:
> Keeping perf_output_copy() inlined is responsible
> of some ugliness there.
> 
> A solution could be to have an internal only
> perf_output_copy_inline() version in internal.h
> and a wrapper in buffer.c that exports it.
> 
> Or we can completely uninline it.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
