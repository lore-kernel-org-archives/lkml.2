Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293Ab1A0FBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 00:01:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47421 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1A0FBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 00:01:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Wd3rzNXMkh5EgT3xnBDQ12mwOA0pvCqFOGxYEwPfo0c625v78Wiux7rh5nEtRP/Yjh
         JJ+a6bx81u1NTjPBw3/Dc+0fOHCPqNgzeHrqdPT34EVdVzmMh6yH2/UNPGvfXAnBOkni
         m6hkSPpRJkfBtnwSjDNVCkRwGUob4K0KgLCbw=
MIME-Version: 1.0
In-Reply-To: <20110126165223.GA6695@tassilo.jf.intel.com>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-11-git-send-email-arnd@arndb.de>
	<m2ipxc34aq.fsf@linux.intel.com>
	<201101261350.42789.arnd@arndb.de>
	<20110126165223.GA6695@tassilo.jf.intel.com>
Date: Thu, 27 Jan 2011 16:01:07 +1100
Message-ID: <AANLkTi=VY5QR7qF512nDB1dMneBQFSRh2NPmt0fckph_@mail.gmail.com>
Subject: Re: [PATCH 10/20] hpfs: replace BKL with a global mutex
From: Nick Piggin <npiggin@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 3:52 AM, Andi Kleen <ak@linux.intel.com> wrote:
> On Wed, Jan 26, 2011 at 01:50:42PM +0100, Arnd Bergmann wrote:
>> On Wednesday 26 January 2011, Andi Kleen wrote:
>> > I don't think that's a very good idea, there's danger
>> > of holding it over IO and that would be really bad (as in like MINIX[1])
>> >
>> > It would be better to do it the i810 way and check for the number of
>> > CPUs at module init time and refuse to run if it's > 1
>>
>> I don't see much value of one evil over the other, but why not. The code
>> is going away anyway unless someone cleans it up further.
>
> I think it's fine because systems running OS/2 likely only have
> one CPU. This way these guys (if they exist) won't see any regression.

It would be really neat if there was a project to destage a lot of
these old filesystems and implement read-only support with fuse
implementations (not that I'm volunteering :P).

I almost think write access to a lot of these old filesystems is pretty
dangerous to support in the kernel due to lack of testing and bitrot.
