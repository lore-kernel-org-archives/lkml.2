Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0KJIIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:08:21 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49655 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0KJIIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:08:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d2c1DTE7QTm+REcNUQ5haj+ATa0hW81N8t9wAMDWNMe6O4WuwsH66foMLZ3vyEclEk
         iEZmXGeW8dwBO7lUQkZIVfjwoKmG0+Dml8+nvGXzVW2Y2z0/VoXfq9Bgl4pEY6qHkGqZ
         bdPLfr9jgPKhQh7GqzqlFjWBDDLgmpHAB8NdU=
MIME-Version: 1.0
In-Reply-To: <20101110013255.GR2715@dastard>
References: <20101105014334.GF13830@dastard>
	<E1PELiI-0001Pj-8g@approx.mit.edu>
	<AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
	<4CD696B4.6070002@kernel.dk>
	<AANLkTikNPEcwWjEQuC-_=9yH5DCCiwUAY265ggeygcSQ@mail.gmail.com>
	<20101110013255.GR2715@dastard>
Date: Wed, 10 Nov 2010 11:08:17 +0300
Message-ID: <AANLkTikAF=Ka_qB5pPzo9wj_jAp=TG2xSbjaGcoLYfBw@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
From: Evgeniy Ivanov <lolkaantimat@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, dave b <db.pub.mail@gmail.com>,
        Sanjoy Mahajan <sanjoy@olin.edu>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 4:32 AM, Dave Chinner <david@fromorbit.com> wrote:
> Don't forget to mention data=writeback is not the default because if
> your system crashes or you lose power running in this mode it will
> *CORRUPT YOUR FILESYSTEM* and you *WILL LOSE DATA*. Not to mention
> the significant security issues (e.g stale data exposure) that also
> occur even if the filesystem is not corrupted by the crash. IOWs,
> data=writeback is the "fast but I'll eat your data" option for ext3.
>
> So I recommend that nobody follows this path because it only leads
> to worse trouble down the road.  Your best bet it to migrate away
> from ext3 to a filesystem that doesn't have such inherent ordering
> problems like ext4 or XFS....

Is it save to use "data=writeback" with ext4? At least are there
security issues?
Why do you say, that fs can be corrupted? Metadata is still
journalled, so only data might be corrupted, but FS should still be
consistent.


-- 
Evgeniy Ivanov
