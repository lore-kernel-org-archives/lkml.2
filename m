Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab1F1GDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:03:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43641 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1F1GC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=BNQMlS6M0bEm5X2vv0N5KVuk3tiLIQ4RSBuSQZh4xU69zQBi/zIjlLhZiey69w5w6k
         5R1YqIA3mFuEHgiVS4ctXg3FR3S08n9Ym1t4EKk/HMsQuDuY/ruJ2fpIuQRCUT0p7uSw
         T3RjUWb/75HrjqklgtcQYVo6lQZ1v79Rk/YG0=
MIME-Version: 1.0
In-Reply-To: <20110627145442.GA2729@thunk.org>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
	<20110627145442.GA2729@thunk.org>
Date: Tue, 28 Jun 2011 14:02:58 +0800
Message-ID: <BANLkTin1cABBLn0yPxk6oyTbw4miN7TEPw@mail.gmail.com>
Subject: Re: random(4) driver questions
From: Sandy Harris <sandyinchina@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 10:54 PM, Ted Ts'o <tytso@mit.edu> wrote:

> Suffice it to say the random generator has changed significantly since
> 2006.  There is now a secondary pool, which uses catastrophic
> reseeding, etc.

Why does the secondary pool use another hash, rather than a
block cipher? I can see using a hash for the primary pool; at
the original design time, export laws were a concern, and in
any case a hash is the obvious mixing primitive there.

However, for the secondary pools, a block cipher seems to
me to be the obvious thing to use because there is plenty
of analysis, in the Yarrow paper and follow-ups, of that
technique. Also, I think it might be faster.

An AES-128 context, 11 128-bit round keys, is roughly the
same size as one of the current secondary pools, 32 32-bit
chunks. What would maintainers think of a patch along
those lines?

Another question is whether and when we might replace
SHA-1 with a more modern hash. Jeff Garzik has a patch
to add Skein to the crypto API. That would be faster
than SHA-1 and perhaps more easily analyzed since
the compression function is a block cipher. Of course
the SHA-3 Advanced Hash Standard process is not
scheduled to finish for another year and there's a
good argument that we should wait for that.

Also, though there are some attacks on SHA-1, none
of them appear to matter for this application, so
perhaps :If it ain't broke, don't fix it".
