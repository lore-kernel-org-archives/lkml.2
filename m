Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab1DZSwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:52:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33299 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab1DZSwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L7veKMuFF4gP/Cy6Ow1SZN0R4wyZZCRYkWMQJ/bbGnWrd4krawWK6PLImqF6GrNpv6
         tGpyo16iEh4L3vkXzXWEwmoiK+kBW5eMh+uY27Nn563ycnjUjs1OXJzRCFGXYAaAjw08
         vNhF1tn+PsHxI2Og1KfWoRepHO6m2LOqJ6gh8=
MIME-Version: 1.0
In-Reply-To: <1303488341.6225.2.camel@gandalf.stny.rr.com>
References: <20110421022825.535486725@goodmis.org>
	<20110421023737.290712238@goodmis.org>
	<4DB19A1E.8070806@bitwagon.com>
	<BANLkTim8mBo3fz9f=quABj-=ycpA+G7q1g@mail.gmail.com>
	<1303488341.6225.2.camel@gandalf.stny.rr.com>
Date: Tue, 26 Apr 2011 15:52:37 -0300
Message-ID: <BANLkTinENP=hpjZBMFp0Y7EKGH8u-gewPA@mail.gmail.com>
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to use
 Linux style comparisons
From: Thiago Farina <tfransosi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: John Reiser <jreiser@bitwagon.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Apr 22, 2011 at 1:05 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-04-22 at 12:52 -0300, Thiago Farina wrote:
>> On Fri, Apr 22, 2011 at 12:09 PM, John Reiser <jreiser@bitwagon.com> wrote:
>> > I consider "0==strcmp(" to be an idiom.  Too often "strcmp(...) == 0"
>> > overflows my mental stack because of the typographic width of the operands
>> > in the source code.  If you still object in this case then please consider
>> > using something like:
>> >        #define strequ(a,b) (strcmp((a), (b)) == 0)
>> > or
>> >        static int strequ(char const *a, char const *b)
>> >        {
>> >                return strcmp(a, b) == 0;
>> >        }
>> > which names the idiom.
>> >
>>
>> Maybe str_eq? Or even just streq? And also just !strcmp(a,b).
>
> streq() is something I woudn't mind.
>
> I've too often confused !strcmp(a,b) as "!streq()" which is not the
> case. Which is why I always use strcmp(a,b) == 0, which to me I see the
> '==' as eq. I also consider strcmp(a,b) != 0 as not equal. Again, the
> mind that sees "==" and "!=" can just translate that to human language.
> Where !strcmp() is just gibberish ;)

I've sent a patch to linux-kernel adding streq macro as suggested and
copied you Steven.

Best regards,
