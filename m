Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab1DVPw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:52:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48788 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab1DVPw4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lcA5yybthxUUHBMGQDz7H9Q5CllBQDAZu3CIk7ZAKvpOO2zeoonYPGYLeawTTTzf0r
         r+QhKvEfgY+tkiA46g4f7a85XouAlRpDXjv+ulc30VUJaf6cVowTcWmo1sJR6o5WWRuk
         p9Sqmc5XhM04j66kXQNR4uoH/ZbKxAfpmGE+M=
MIME-Version: 1.0
In-Reply-To: <4DB19A1E.8070806@bitwagon.com>
References: <20110421022825.535486725@goodmis.org>
	<20110421023737.290712238@goodmis.org>
	<4DB19A1E.8070806@bitwagon.com>
Date: Fri, 22 Apr 2011 12:52:55 -0300
Message-ID: <BANLkTim8mBo3fz9f=quABj-=ycpA+G7q1g@mail.gmail.com>
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to use
 Linux style comparisons
From: Thiago Farina <tfransosi@gmail.com>
To: John Reiser <jreiser@bitwagon.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 12:09 PM, John Reiser <jreiser@bitwagon.com> wrote:
> I consider "0==strcmp(" to be an idiom.  Too often "strcmp(...) == 0"
> overflows my mental stack because of the typographic width of the operands
> in the source code.  If you still object in this case then please consider
> using something like:
>        #define strequ(a,b) (strcmp((a), (b)) == 0)
> or
>        static int strequ(char const *a, char const *b)
>        {
>                return strcmp(a, b) == 0;
>        }
> which names the idiom.
>

Maybe str_eq? Or even just streq? And also just !strcmp(a,b).
