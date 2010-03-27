Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0C0WvG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:51:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:48353 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab0C0WvC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YavNwvs4ffcizydQZPELuAnq4CKe35ZUpoKlhZ5a3f9ySL+sqlP8c46VH+nNIoSc6s
         7MYItCdGaNK4I251HEk+pWK5ttunrSewZznjhUrl0Q5RULkhFEHYgYwctW/MiNkixeOl
         7RPaFbg/d/ffiqU43tLhj7nsx5KKG7CBbzOfI=
MIME-Version: 1.0
In-Reply-To: <20100327220355.GA1810@mail.oracle.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
	 <20100326214648.GF9984@mail.oracle.com>
	 <20100326180025.052d930f@penta.localdomain>
	 <20100327005710.GA31009@mail.oracle.com>
	 <20100326220259.702859e9@penta.localdomain>
	 <20100327220355.GA1810@mail.oracle.com>
Date: Sat, 27 Mar 2010 18:51:01 -0400
X-Google-Sender-Auth: 381473215e5d791d
Message-ID: <ea182b21003271551k10d0ef1oa0757ba921f1870f@mail.gmail.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
From: Yury Polyanskiy <ypolyans@princeton.edu>
To: Yury Polyanskiy <ypolyans@princeton.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, john stultz <johnstul@us.ibm.com>,
       Jan Glauber <jan.glauber@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 6:03 PM, Joel Becker <Joel.Becker@oracle.com> wrote:
> On Fri, Mar 26, 2010 at 10:02:59PM -0400, Yury Polyanskiy wrote:
>> Joel, just realized there is a slight mistake in what I said before.
>> getrawmonotonic() is a refined jiffies (and actually resolves to
>> get_cycles() on my system in the end). Thus it doesn't count while in
>> suspend. However, jiffies-based timers (aka timer-wheel) are also
>> stopped while in suspend. So getrawmonotonic() is the right call to
>> check the precision of the jiffies-based timer (i.e. you dont need to
>> make a correction by calling monotonic_to_bootbased()).
>
>        It's OK to tell hangcheck-timer users that suspend is not
> allowed.  After all, you're running something that you don't want to see
> hang.

Joel, what I am saying is exactly the opposite: it is totally ok to
suspend-resume with hangcheck-timer (jiffies are stopped and so is
getrawmonotonic() when system suspended).

>        Is there a clock in the system that is a true wallclock?  I'm
> guessing, since getrawmonotonic() is get_cycles() based, that it doesn't
> provide accurate time in the face of cpufreq changes.  Is that true?

Of course, getrawmonotonic accounts for cpufreq changes (see
arch/x86/kernel/tsc.c:time_cpufreq_notifier()).


Yury
