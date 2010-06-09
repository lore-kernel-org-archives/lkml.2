Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0FIHoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 03:44:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37739 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0FIHoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 03:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CEQrmhP3RDn4+PkVkTx0IjYOwQ+Gvt5s12mI8afRwkczReTTf6q2chPVQSstT0T96z
         yugiL+H/QK+rTF6DegaxBFJsAd/ZYRj85Uph5J1BLoe7ZSSxcvhr3soxhVgearB4PhOp
         8Lyne92R5iSm6hlgRAAOn17gzqsqHtZdTPOas=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006082042020.4506@i5.linux-foundation.org>
References: <20100603193045.GA7188@elte.hu>
	<AANLkTinQyzzeF-NOAjrAqqQXqKjFJhx85nI4uyBGRtWd@mail.gmail.com>
	<1275653210.27810.39762.camel@twins>
	<AANLkTinyjBa0KYfFz3_EFbC65hoQFwFINlTDYjCe-wM3@mail.gmail.com>
	<1275731653.27810.41078.camel@twins>
	<20100605092851.6ee15f13@infradead.org>
	<AANLkTimEwznq9c_8lkuBMxEQ-42rdvpZEqA9Y71Cu-qC@mail.gmail.com>
	<AANLkTimKknOurmCffOpHjc1FjrP2MKf10pBwEEbLJPg_@mail.gmail.com>
	<AANLkTil1NCX91bWhpXHtC88Opr29mNjdhXD9RXQ6DI0y@mail.gmail.com>
	<AANLkTin1Za3GvfIKbcZdx6TzjIHzCvsg5uaY_Vk4nJIh@mail.gmail.com>
	<AANLkTilQ1k78dDCYadOa1Wiyjm2nsBcRpxwdpGvYcf8z@mail.gmail.com>
	<AANLkTin7oM3gVwHbIHWqYV8yeC6bbQ4q2jDDxAgz3DwQ@mail.gmail.com>
	<alpine.DEB.2.01.1006060305060.17462@asgard.lang.hm>
	<AANLkTinW-X5m85rUcqP-lrEdfBikVclJWgqiWDkpxnAc@mail.gmail.com>
	<20100606124949.539fa636@schatten.dmk.lab>
	<alpine.DEB.2.01.1006060410050.17462@asgard.lang.hm>
	<20100607141624.3d004db2@schatten.dmk.lab>
	<alpine.DEB.2.01.1006081759150.17462@asgard.lang.hm>
	<alpine.LFD.2.00.1006082042020.4506@i5.linux-foundation.org>
Date: Wed, 9 Jun 2010 10:43:58 +0300
Message-ID: <AANLkTino9hnqao9402dR543MIlf66qYYjxrknHrxd39o@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@lang.hm, Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Brian Swetland <swetland@google.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 9, 2010 at 6:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, 8 Jun 2010, david@lang.hm wrote:
>>
>> having suspend blockers inside the kernel adds significant complexity, it's
>> worth it only if the complexity buys you enough. In this case the question is
>> if the suspend blockers would extend the sleep time enough more to matter. As
>> per my other e-mail, this is an area with rapidly diminishing returns as the
>> sleep times get longer.
>
> Well, the counter-argument that nobody seems to have brought up is that
> suspend blockers exist, are real code, and end up being shipped in a lot
> of machines.
>
> That's a _big_ argument in favour of them. Certainly much bigger than
> arguing against them based on some complexity-arguments for an alternative
> that hasn't seen any testing at all.
>
> IOW, I would seriously hope that this discussion was more about real code
> that _exists_ and does what people need. It seems to have degenerated into
> something else.
>
> Because in the end, "code talks, bullshit walks". People can complain and
> suggest alternatives all they want, but you can't just argue. At some
> point you need to show the code that actually solves the problem.

That's assuming there is an actual problem, which according to all the
embedded people except android, there is not.

And if there is indeed such a problem (probably not big), it might be
solved properly by the time suspend blockers are merged, or few
releases after.

Whatever the solution (or workaround) is, it would be nice if it could
be used by more than just android people, and it would also be nice to
do it without introducing user-space API that *nobody* likes and might
be quickly deprecated.

-- 
Felipe Contreras
