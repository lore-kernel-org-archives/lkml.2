Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0JVEMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 00:12:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49889 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab0JVEMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 00:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MvVxKg3IStbkY3SZ/QVaL8LycLx4m0/+9PbvgKeNOgOnq89VdIQns+94IzobjIuEIh
         QV5Sjda3o06Uu75BfCs9yTdytKE9KsdB4oSrZS/R6skNLn6tZx83DO76BRJtMlx0t5bt
         qePiCjPw/c0bcZYHFAEmfblxBXJfvtE2v5u4E=
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Nick Piggin <npiggin@kernel.dk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101021174536.26213ab7.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
	 <1287221475.2799.123.camel@edumazet-laptop>
	 <1287238754.2799.376.camel@edumazet-laptop>
	 <20101021153719.c8bde251.akpm@linux-foundation.org>
	 <alpine.DEB.2.00.1010211807280.3431@router.home>
	 <20101021174536.26213ab7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 06:12:05 +0200
Message-ID: <1287720725.7984.3.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 17:45 -0700, Andrew Morton a écrit :

> this_cpu_add_return() isn't really needed in this application.
> 
> {
> 	this_cpu_add(*fbc->counters, amount);
> 	if (unlikely(abs(this_cpu_read(*fbc->counters)) > fbc->batch))
> 		out_of_line_stuff();
> }	
> 
> will work just fine.				

Hmm, you cannot do this on 32bit machines because "amount" is 64bit
wide.

Switching counters to s64 is not an option (makes summation racy, and
memory use bigger)



