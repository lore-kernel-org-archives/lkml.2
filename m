Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966Ab0HLQY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 12:24:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49637 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab0HLQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 12:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=N7vnIvTgHgzCppYqdYhqtUjmq7Q4MfeoLWH4mBZiMTuum5K887NnpL1OpsFgqCPvZ+
         zV2/RpoPSya2rBrg0P1HsbtHM8qsTz2HM9ooX5s+h6UbbAwhH+zNDZydBSjWMXjmX6jR
         UiBrsdnoT8qhR6aCeCactmjXUtjRlrLtQZcf0=
MIME-Version: 1.0
In-Reply-To: <AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
References: <1274733081-4623-1-git-send-email-walken@google.com>
	<1274733081-4623-7-git-send-email-walken@google.com>
	<AANLkTikFEy26V4epRGCJiDkQNQ5BH0fPP0C=4phUB=o3@mail.gmail.com>
	<AANLkTimDGbrja5EgGQ+sQxHBRNMnmt7=rjtOfwAKEKFe@mail.gmail.com>
	<AANLkTim3thKSwTHSQ7UXir+1cT9cfFaEjTFGGMdz0_Bt@mail.gmail.com>
	<AANLkTikz2=pa5csA+pqDfKc_zYihyn+C9pUb_YNS9g0L@mail.gmail.com>
Date: Thu, 12 Aug 2010 09:24:43 -0700
X-Google-Sender-Auth: l1m2es1ydN-vLDY-JYqOiLh2y3g
Message-ID: <AANLkTiny_GOfvX-t=SoXZVi8uO3SHC_h2YgbPtCcLXcu@mail.gmail.com>
Subject: Re: [PATCH 06/11] rwsem: wake queued readers when writer blocks on
 active read lock
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>, David Howells <dhowells@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Waychison <mikew@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 8:57 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Tony, can you verify that just dropping the "__IA64_UL_CONST" makes
> things work for you? Having a non-working rwsem makes me really
> nervous, but considering the lack of reports on other architectures, I
> really do hope this is just a trivial ia64 signedness difference.

Yes it does. Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6.git release

to get this fix.

-Tony
