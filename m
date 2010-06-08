Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0FHJpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:45:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48713 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0FHJp3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:45:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TCdhr3eLaqAdU8vJhLO57j0oNgVvcdcHKTqYB1eXTTekgPjkfVWTyrWE1ympukHaNz
         HLgoAniAEDWP6NvNsK/Rx37GbO3Qb1hVJjxWg6sPB2uUKIpqMNH7Q+6NwfDnRJzFVOXa
         Qz7dXFuw7Hng/gDlheA+HzqvWoqy+jNZiuLe8=
MIME-Version: 1.0
In-Reply-To: <87aaybwrny.fsf@basil.nowhere.org>
References: <b64f365b0911171252q42a0c102jddb2cd29af64a7a7@mail.gmail.com>
	<87aaybwrny.fsf@basil.nowhere.org>
Date: Tue, 8 Jun 2010 12:45:26 +0300
Message-ID: <AANLkTinO-roipX4Euj1R3AdxBbY3RZSJXjVtLIpwDWSK@mail.gmail.com>
Subject: Re: [RFC] Using "page credits" as a solution for common thrashing 
	scenarios
From: Eyal Lotem <eyal.lotem@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to a very old email :-)

On Wed, Nov 25, 2009 at 12:15 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Eyal Lotem <eyal.lotem@gmail.com> writes:
>
> Replying to an old email.
>
>>   * I think it is wrong for the kernel to evict the 15 pages of the bash,
>>     xterm, X server's working set, as an example, in order for a
>>     misbehaving process to have 1000015 instead of 1000000 pages in its
>>     working set. EVEN if that misbehaving process is accessing its working
>>     set far more aggressively.
>
> One problem in practice tends to be that it's hard to realiably detect
> that a process is misbehaving. The 1000000 page process might be your
> critical database, while the 15 page process is something very
> unimportant.

Well, this solution doesn't really depend on any detection of
"misbehaving", it just goes about a more accurate way of defining page
importance.  A simple solution to the problem you suggest is assigning
far more "credits" to the database than to the 15-page process.

Eyal

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
