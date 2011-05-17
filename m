Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1EQJps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:45:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60998 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab1EQJpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:45:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b0a2Y2NhMcDzkgO31yQsl1Kc/Z39l8CM5sX83Bib+NgMWKrYQGuEloXpdlq+sPrl25
         UKoofMoQzAG0v8vPFcjTh8GM5qIkmaFdzI+XZbwwq65u3WVSgQxS099K2TrGP+UNgiQy
         QERm+128NfaVz8aK+NygXHP9ViZdEXjASVelw=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110517091102.GE20624@htj.dyndns.org>
References: <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
	 <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
	 <1305608212.9466.45.camel@edumazet-laptop>
	 <1305609768.2375.84.camel@sli10-conroe>
	 <1305622861.2850.21.camel@edumazet-laptop>
	 <20110517091102.GE20624@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 11:45:41 +0200
Message-ID: <1305625541.2850.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 11:11 +0200, Tejun Heo a écrit :

> I'm completely fine with #1.  I'm not that crazy but I don't really
> want to take #2 - that makes the whole _sum() interface almost
> pointless.  

Hi Tejun

_sum() is a bit more precise than percpu_counter_read(), but to make it
really precise, we means we have to stop concurrent activities, and we
never did in previous/current implementation.

We could add this (as Shaohua and myself tried in various patches)
later, if needed, but nowhere in kernel we currently need that.

Even /proc/meminfo doesnt call _sum(&vm_committed_as) but the lazy
percpu_counter_read_positive() function...

Reammy _sum() gives a good approximation of the counter, more precise
because of the percpu s32 folding, but no guarantee of deviation.



