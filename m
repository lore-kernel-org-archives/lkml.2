Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab0DAUcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:32:19 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:50297 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0DAUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=GHJ6Xf0e802nCiZBJEETsy/MeuSQ9oIuE+4oNI284ntG5g/liRHyHOENK0dTbQ8JOl
         Le4/5Koc7HFzyJbhQYn5H9hm9LlH8C03apnTjOUVkOYvHEa0cNsO39KaxcU3EICZKK2G
         ZkA9l76tsvBck3SKZFjW73I3KxJVUblFrLJts=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	 <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
	 <20100401122740.a1ae80a7.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004012133570.32352@localhost.localdomain>
	 <h2s40ec3ea41004011300zaa5699f0kcf07434fec9b1aab@mail.gmail.com>
	 <alpine.LFD.2.00.1004012203270.32352@localhost.localdomain>
Date: Thu, 1 Apr 2010 16:32:15 -0400
X-Google-Sender-Auth: ac26097d4ece914c
Message-ID: <m2k40ec3ea41004011332t80436b03q69ff8cad735037a@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting till 
	after load update period
From: Chase Douglas <chase.douglas@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 4:18 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Also we need to think about a more clever way than just accounting the
> number of running and uninterruptible tasks. What we really want is to
> use the numbers which the scheduler has handy, i.e how many tasks did
> we run since we did the last loadavg calculation. It was always
> possible (even before the big loadavg changes) to create a task which
> consumes 50% of a CPU and never shows up in the loadavg calculations
> at all.

I'm not sure I follow how knowing how many tasks have been run since
the last LOAD_FREQ expiration will help, or is that just an example of
the kind of data the scheduler has available that may be useful?

-- Chase
