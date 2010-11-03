Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab0KCHMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 03:12:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43881 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab0KCHMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=f5j9m5Ku1ra7fHQAJohHddFmDy/n3BJywIgOBw+F8CaJp4SWLc1NExooadY8G4HMUx
         b4RZr0YQAyM0gBUX4H+FKO1mLVhQCygMpqOyUhBZZX+ZBsx+TC5k/tE7akrGZdeABOOK
         q+tz2AmB+Yfa3UTEerj5Amvxqq1iVyfT6oLUU=
Subject: Re: [RFC 4/4]x86: avoid tlbstate lock if no enough cpus
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <1288767995.23014.120.camel@sli10-conroe>
References: <1288766668.23014.117.camel@sli10-conroe>
	 <1288767580.2467.636.camel@edumazet-laptop>
	 <1288767995.23014.120.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 08:12:10 +0100
Message-ID: <1288768330.2467.660.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 15:06 +0800, Shaohua Li a écrit :
> just don't want to include the non-present cpus here. I wonder why we
> haven't a variable to record online cpu number.

What prevents a 256 cpus machine, to have 8 online cpus that all use the
same TLB vector ?

(Max 32 vectors, so 8 cpus share each vector, settled at boot time)

Forget about 'online', and think 'possible' ;)



