Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab2EIXVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:21:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51576 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab2EIXVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120509145956.97b4ff63.akpm@linux-foundation.org>
References: <20120504182114.24883.40748.stgit@beardog.cce.hp.com>
	<20120509145956.97b4ff63.akpm@linux-foundation.org>
Date: Wed, 9 May 2012 18:21:37 -0500
Message-ID: <CADzpL0Qs_4SZeR-E_TCnagQQwNR3OC_ncOGZpGS62dNPtCwfdw@mail.gmail.com>
Subject: Re: [PATCH] cciss: fix incorrect scsi status reporting
From: Stephen Cameron <stephenmcameron@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, axboe@kernel.dk,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com, roel.vanmeer@bokxing.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 4:59 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 04 May 2012 13:21:14 -0500
> "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
>
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>
>> Delete code which sets SCSI status incorrectly as it's already
>> been set correctly above this incorrect code.  Bug was introduced
>> by b0e15f6db1110319cb2e747e59e1200450a5ba3e
>> "cciss: fix typo that causes scsi status to be lost." in 2009.
>>
>> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>> Reported-and-tested-by: Roel van Meer <roel.vanmeer@bokxing.nl>
>> Cc: stable@vger.kernel.org
>
> If the bug is three years old, it presumably isn't a terribly serious
> one.  Why was the -stable backport recommended?

(added roel.vanmeer@bokxing.nl to cc list)

Due to my subjective interpretation of stable_kernel_rules.txt,
specifically this part:

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.

I thought it fell under the "oh, that's not good", in that, according
to the tester, iirc, it made his tape drive not show up at all, which
seemed bad (though not a symptom I observed directly), and it seemed
like a trivial fix to something obviously incorrect, so thought stable
might like to know about it.  But, maybe not.

-- steve
