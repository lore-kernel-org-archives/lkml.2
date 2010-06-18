Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0FRDKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:10:35 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:35550 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753343Ab0FRDKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:10:31 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: 5meoFfMVM1kTa2MMk4s4x397LefdDGF97I0tQZnlVIyLQ4Z
 oq.ZyDMjVXN3.AVQwbJiEnlAMf44YqQOHk.oHC9zp7bGmP.KaY85008uj_ay
 DaucKAEFltR8y3m99NoSsfHAnw_HyRoRaplZ3dLWCnniz1o9NIurygC9Ofl7
 xikTr9Jvh33.yk4L5PLCHta9v7eINtla9jhjcv1H07X1ffU0aaSI0qluhnJt
 c6UXJ406y9kln5Od65xh54kcAb9mJGXKHFzL79e4BC84ADZ_EZyNCUjR2hnk
 5HvzflCuBrlDC7U3XKrwoQ5UbXQUvW7IOLSfC5x5wk1JPESYX8HzAI4KD
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4C1AE3A8.2020104@schaufler-ca.com>
Date: Thu, 17 Jun 2010 20:10:32 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Kees Cook <kees.cook@canonical.com>, Randy Dunlap <rdunlap@xenotime.net>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
References: <20100616221833.GM24749@outflux.net>	<20100617000120.13071be8@lxorguk.ukuu.org.uk>	<20100616232230.GP24749@outflux.net>	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>	<20100617170453.GV24749@outflux.net>	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>	<20100617140630.c6ced27a.rdunlap@xenotime.net>	<20100617221815.68ce30c5@lxorguk.ukuu.org.uk>	<20100617215105.GB24749@outflux.net> <20100617233054.330256cf@lxorguk.ukuu.org.uk>
In-Reply-To: <20100617233054.330256cf@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The "just use SELinux" reply is tiresome.  If "everyone" used SELinux,
>> there wouldn't be at least 3 other LSMs under active development.
>>     
>
> People using SELinux, SMACK and the other LSMs already *have* this
> feature (done right, unlike the version you posted).
>
>   
>> The PTRACE, symlink, and other stuff are features people want.  If the
>> point of your argument is that the logic and configuration for each
>> of these features should be added to every LSM, that's not sensible.
>> An end user should be able to pick and choose what they want.  If I
>> create the security/hideous/ LSM tree, it would _exclude_ the ability to
>> use TOMOYO or Smack or SELinux or AppArmor.
>>     
>
> This is like trying to have two different file systems on the same
> partition at once. We tried stackability - the reason LSMs don't currently
> stack neatly is because it turned out to be a very bad idea.
>   

That's not quite how I remember it, and at the time I was on the
anti-stacking side. My recollection is that the issue was not that
stacking was a bad idea but that stacking SELinux and AppArmor was
a bad idea. Stacking two "complete" security "solutions" is still
as bad an idea today as it was at the turn of the century. That
was followed by an extended period during which there was only one
LSM and not a whole lot of incentive to make sure that the LSM
remained a clean interface.

> If you want to fix that by implementing a stacking LSM which has your
> switches then do that.
>   

I have changed from anti-stacking to pro-stacking for the simple
reason that where I used to think that is was possible to create
a single cohesive security story in an OS I now believe that doing
so is only possible in a brand new OS, and that the best we can do
in the face of an install base is provide for the rapid deployment
of schemes that make sense to people born after the Orange Book
was published. And no, you can't do that with SELinux policies.

>   
>> At present, I'm aware of global PTRACE control being possible in SELinux,
>> AppArmor, grsecurity, and as a patch in Ubuntu's kernel.  I don't know
>> about TOMOYO or Smack, but configuring the default scope of PTRACE in
>> at least 4 different ways so far (or not being able to change it at all)
>> just seems crazy.
>>     
>
> So you want to add a fifth. It won't replace the others because its not
> as flexible. How does having five help ?
>
>   
>> If the security API allowed the end user to pick and choose the features
>> they wanted, then those features would be developed in a single place
>> and configured in a single way.  Since that's not possible, I'm proposing
>> these features be central, and configured via /proc/sys.
>>     
>
> They *are* central, which is why we have the security directory and the
> security hooks abstracted into one central location.
>
> So if you care about everyone then do it right - put it in its own LSM.
> After that or in parallel you can look at how it needs to interact to
> make it stackable. That's a door that the integrity/ima work has partly
> re-opened already.
>
> Really you have three choices
>
> - You can keep trying to put stuff in places it doesn't belong, in which
>   case you'll keep getting NAKs from people like Christoph and from Al
>   Viro and then give up.
>
> - You can give up now.
>
> - You can put it together as a security module - which will make people
>   happy and get your stuff upstream. After that you can have a meaningful
>   discussion about stacking, although I think you'll find that stacking
>   is really really hard because you get conflicting behaviour between
>   security modules and ignoring those conflicts ends up violating at least
>   one of the security models leaving you worse not better off.
>
> Your path to making any of the stuff you want happen is via the security
> layer and the LSM hooks. Even if you want them stackable and usable with
> other modules your starting point is still a security module.
>   

I agree. Worst (Best?) case is everyone sees how great it is and
it gets pulled out of your LSM and into the "code proper". I seem
to recall a movement to do that with another LSM a few years back,
and the fact that it didn't happen there doesn't mean it can't
happen ever.

> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   

