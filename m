Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0D0VHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:07:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:43865 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0D0VHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rgdSWybrtGiNaJUz8Q/MdZay2r87P8ERSNc9eXzyJwjPQ3/iaE88K/fRxLf1rRey66
         LgcNQvFM1myUtFy1ADaMvSOcZTFo1XgBH95BKTZlaggztEnDYTj8ju+ZpW7YHLh/wKHB
         lpFcEYUE+/s3ZW5uZz/Rcw/Q0B8qSRkSmytoQ=
MIME-Version: 1.0
In-Reply-To: <20100427132607.49c68196.akpm@linux-foundation.org>
References: <1268258994.2183.14.camel@carter>
	 <ca2dc2821003210830h2025df79r477cca7d81ddd28d@mail.gmail.com>
	 <20100322205704.ac4cd9ae.akpm@linux-foundation.org>
	 <alpine.DEB.2.01.1003222111070.5493@bogon.housecafe.de>
	 <ca2dc2821003230440w3d96612aja0d4e083d3cc8c02@mail.gmail.com>
	 <20100324111436.fe5d2906.akpm@linux-foundation.org>
	 <ca2dc2821003250955x211ef2f8la16ded9759ccb6ab@mail.gmail.com>
	 <20100427105750.1cfe59b9.akpm@linux-foundation.org>
	 <n2tca2dc2821004271306nfc0c9c76o143b796e8af6ced8@mail.gmail.com>
	 <20100427132607.49c68196.akpm@linux-foundation.org>
Date: Tue, 27 Apr 2010 23:07:39 +0200
Message-ID: <v2gca2dc2821004271407o59e3e2d4n135bb050510a2e63@mail.gmail.com>
Subject: Re: [PATCH] intel-agp.c: Fix crash when accessing nonexistent GTT 
	entries in i915
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Kujau <lists@nerdbynature.de>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, David.Woodhouse@intel.com,
       dwmw2@infradead.org, eric@anholt.net, ben@decadent.org.uk,
       gregkh@suse.de, Dave Airlie <airlied@linux.ie>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 10:26 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 27 Apr 2010 22:06:21 +0200
> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>
>> On Tue, Apr 27, 2010 at 7:57 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Thu, 25 Mar 2010 17:55:56 +0100
>> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >
>> >> On Wed, Mar 24, 2010 at 7:14 PM, Andrew Morton
>> >> <akpm@linux-foundation.org> wrote:
>> >> > On Tue, 23 Mar 2010 12:40:05 +0100
>> >> > Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >> >
>> >> >> On Tue, Mar 23, 2010 at 5:14 AM, Christian Kujau <lists@nerdbynature.de> wrote:
>> >> >> > On Mon, 22 Mar 2010 at 20:57, Andrew Morton wrote:
>> >> >> >> On Sun, 21 Mar 2010 16:30:20 +0100 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >> >> >> > I bisected in order to find the commit 5877960869333e42ebeb733e8d9d5630ff96d350.
>> >> >> >
>> >> >> > I believe this[0] is fc61901373987ad61851ed001fe971f3ee8d96a3 upstream:
>> >> >>
>> >> >> Indeed. Also in
>> >> >>
>> >> >> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=commit;h=fc61901373987ad61851ed001fe971f3ee8d96a3
>> >> >
>> >> > Does reverting that patch from the current code fix the crash?
>> >>
>> >> Yes. In addition, applying the patch I provided also fixes it in current code.
>> >>
>> >
>> > Well great. __A whole pile of new stuff has turned up in linux-next's
>> > drivers/char/agp/intel-agp.c. __As far as I can tell none of it
>> > address the regression which you've reported and your patch no longer
>> > applies at all so I have to drop the patch.
>> >
>> > Perhaps "agp/intel: put back check that we have a driver for the
>> > bridge" fixes it, but it isn't tagged for -stable backporting.
>>
>> I can try linux-next and see if it works again.
>
> Thanks.
>
>> In addition, I have to test the regression with some newer X version
>> yet, as Zhenyu told me.
>
> That would seem to be counter-productive.  If you install a newer X and
> the bug goes away, you've just gone and made it harder for yourself to
> reproduce the bug.
>

Oh, of course. I meant compiling the latest version somewhere and have
both versions ready (the Debian's one and the one from x.org).
