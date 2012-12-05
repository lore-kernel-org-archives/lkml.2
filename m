Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2LEUUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:20:39 -0500
Received: from moth.iki.fi ([212.16.111.74]:57387 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2LEUUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:20:38 -0500
X-Greylist: delayed 498 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 15:20:38 EST
Message-ID: <50BFAA9F.7090001@moth.iki.fi>
Date: Wed, 05 Dec 2012 22:12:15 +0200
From: Markku Savela <msa@moth.iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "Serge E. Hallyn" <serge@hallyn.com>,
        "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com> <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com> <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com> <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com> <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com> <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com> <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com> <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
In-Reply-To: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 09:32 PM, Andy Lutomirski wrote:
>> >Anyway, implementing the features you want in a new module is encouraged,
>> >so long as the behavior of existing module stays the same.
> I'll think about it some more and do it possibly using a sysctl.
> Adding this kind of stuff in a module is asking for even worse
> incomprehensibility of which capability bit means what.

For what is worth, and just for information. This module approach
has been attempted, sort of: I did implement capabilities inheritance
in Nokia N9 (Aegis). The capabilities started to inherit when task
entered "aegis mode" (a bit in secure bits).

The experience was "interesting". There are many "simplified" articles
about running root with less than full capabilities, and we did that.
However, it also caused a lot of headache, because many people got
hit by this "root is no more omnipotent" thing and complained. It was
a pain to manage and find correct required for each task and often
end result was to grant all (or at least too much).



