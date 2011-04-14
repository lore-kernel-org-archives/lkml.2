Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1DNVur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:50:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55200 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1DNVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=N0FHu8QzbP8d59CMMTB+uCEig0Q0Q9GFk8JKAR0wdgWnx6ALLIJXIGfdo1ShcP5Wnb
         KwObxdda30OvQL+8CBoAgeXazT7jfgygvRBPQWECb96PRl/PyghgPV9wLhOgQw8QOnQz
         d3dNwoBLKaFEQM9WDx84xcMM5Q5AeT3dWbLfs=
Subject: Re: [PATCH V4] futex: set FLAGS_HAS_TIMEOUT during demux for
 FUTEX_WAIT
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Stable <stable@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        John Kacur <jkacur@redhat.com>
In-Reply-To: <ef361f98ac0e0771c14ec7facb5b41086eb4ba50.1302817381.git.dvhart@linux.intel.com>
References: <ef361f98ac0e0771c14ec7facb5b41086eb4ba50.1302817381.git.dvhart@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 23:50:38 +0200
Message-ID: <1302817838.2744.42.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 14:43 -0700, Darren Hart a écrit :
> The FLAGS_HAS_TIMEOUT flag was not getting set, causing the restart_block to
> restart futex_wait() without a timeout after a signal.
> 
> Commit b41277dc7a18ee332d in 2.6.38 introduced the regression by accidentally
> removing the the FLAGS_HAS_TIMEOUT assignment from futex_wait() during the setup
> of the restart block. Restore the originaly behavior.
> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=32922
> 
> V2: Added references to commit message.
> V3: Set flag during restart block instead of do_futex()
> V4: Correct stupid order of assignment mistake pointed out by Eric
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Reported-by: Tim Smith <tsmith201104@yahoo.com>
> Reported-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: John Kacur <jkacur@redhat.com>
> ---


Thanks Darren

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


