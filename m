Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab1ATNQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 08:16:06 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41718 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab1ATNQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:16:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FuOljN+EFHOLANMoCov42fbTSPndp/JOEHXDXAwGEfbqZBtu1BO55SlHZYERRpvz8V
         Fyfte0e7x2/eUKXc+eeKtyAxlWcE/EPD/Lspu+SwnNghJFEPQTy1DINSfgFoVqg4z3n0
         fSH4rF4EvBBYX/JkNdtNylyCGJblGyyD1+tOs=
MIME-Version: 1.0
In-Reply-To: <20110120124730.GA7284@infradead.org>
References: <9e7aa896-ed1f-4d50-8227-3a922be39949@default>
	<4D382B99.7070005@vflare.org>
	<20110120124730.GA7284@infradead.org>
Date: Thu, 20 Jan 2011 15:16:00 +0200
X-Google-Sender-Auth: epjHnyO4zurBREhzDsHAv0LK0nY
Message-ID: <AANLkTim4t4zT5W0TJ7Vwzb568u1W6vz3b_cZirfK0Uhs@mail.gmail.com>
Subject: Re: [PATCH 0/8] zcache: page cache compression support
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, Jan 20, 2011 at 07:33:29AM -0500, Nitin Gupta wrote:
>> I just started looking into kztmem (weird name!) but on
>> the high level it seems so much similar to zcache with some
>> dynamic resizing added (callback for shrinker interface).
>>
>> Now, I'll try rebuilding zcache according to new cleancache
>> API as provided by these set of patches. This will help refresh
>> whatever issues I was having back then with pagecache
>> compression and maybe pick useful bits/directions from
>> new kztmem work.

On Thu, Jan 20, 2011 at 2:47 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Yes, we shouldn't have two drivers doing almost the same in the
> tree.  Also adding core hooks for staging drivers really is against
> the idea of staging of having a separate crap tree.  So it would be
> good to get zcache into a state where we can merge it into the
> proper tree first.  And then we can discuss if adding an abstraction
> layer between it and the core VM really makes sense, and if it does
> how.   But I'm pretty sure there's now need for multiple layers of
> abstraction for something that's relatively core VM functionality.
>
> E.g. the abstraction should involve because of it's users, not the
> compressed caching code should involve because it's needed to present
> a user for otherwise useless code.

I'm not sure which hooks you're referring to but for zcache we did this:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b3a27d0529c6e5206f1b60f60263e3ecfd0d77cb

I completely agree with getting zcache merged properly before going
for the cleancache stuff.

                        Pekka
