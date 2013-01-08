Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3AHRN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:13:59 -0500
Received: from nm16.access.bullet.mail.mud.yahoo.com ([66.94.237.217]:36505
	"EHLO nm16.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756684Ab3AHRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:13:57 -0500
X-Yahoo-Newman-Id: 489220.7729.bm@smtp107.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cpXC7vEVM1kfinejUoZ3ezd7tHspAubkJ3USIgZeN528t1X
 ccFOVz2j9.EStFfOXSiranllIg1w6.0zdAkU6IdYCVNqDzA_L59Qmws5U8n4
 yEDEAgbQzIhqySMqzENBNbk60VTKt42LrhrVdNBx.RXMwNY0W981olDm8f94
 xuqdrlGk0psc3N18zDc382wMz6OPb8vO1M.FmPE07Sn29.L5jAqxkwoFL9Wl
 QhDRMCaoVxY7JSj4jIcU5v6CBmo3m6fplCVYK36BbkCqaMWSyThcAG81y8Sm
 jj8bWAoEgUvAKeJteYgt5cFreicpDWyK.8dno5CJN7S6MUL2uBaSGEE3Hesa
 7DpbxABn6hDohMdWkHxgRHu5yYDlEy60Przm6UlxbVpwKCdAvA5inca1AQQ1
 O0iRG3lQVBSOMjL_LMm3dzZI5YVAqXdNhvH9pdMamLfGPsbNPbVQUTx0gf_.
 sU3pz
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EC53E3.6070606@schaufler-ca.com>
Date: Tue, 08 Jan 2013 09:14:11 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com> <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2013 1:12 AM, James Morris wrote:
> On Mon, 7 Jan 2013, Casey Schaufler wrote:
>
>> There has been an amazing amount of development in system security
>> over the past three years. Almost none of it has been in the kernel.
>> One important reason that it is not getting done in the kernel is
>> that the current single LSM restriction requires an all or nothing
>> approach to security. Either you address all your needs with a single
>> LSM or you have to go with a user space solution, in which case you
>> may as well do everything in user space.
> This sounds like a very spurious argument.  If the development is better 
> done in userspace, then do it there.

When the security scheme is better implemented in user space
because it requires information available in user space I agree.
When the security scheme is implemented in user space because
the environment for building it in the kernel is not up to
modern development paradigms I disagree. If you can't work on
two aspects of your security independently you're not going
to keep up with the Jones'.

> There's no way to address all your security needs with an LSM in any case, 
> for any practical system.

Please review the arguments made in support of dropping the
LSM entirely in favor of SELinux as *the* Linux security
infrastructure.

I certainly agree that no one LSM covers all need today.
I also agree that no single LSM will ever meet everyone's
needs. My solution is to allow multiple LSMs so that it is
easier to approach the goal.

> LSM is an API for making security decisions 
> about kernel flow, usually as part of implementing access control 
> mechanisms.  It is not meant to provide any kind of total security 
> solution, and the argument that you can't do some security in userspace is 
> totally illogical.

What I was hoping to say, and apparently didn't, is that people
are developing "total" solutions in user space, when some of the
work ought to be done in an LSM. Work that is appropriate to the
kernel is being done in user space. Often badly, because the
kernel provides too many mechanisms to circumvent user space
based access controls.

> Development should be done in userspace unless it must be done in the 
> kernel.

And we'll be arguing what "must" means long after penguins get the vote.

User space code does not have the opportunity to control the
objects that the kernel manages. Nor should it. Files, sockets,
network packets and signals all must be managed in the kernel.
Some of the user space attempts we're seeing are pretty scary.

>> Multiple concurrent LSMs allows a system to be developed incrementally
>> and to combine a variety of approaches that meet new and interesting
>> needs. It allows for systems that are based on an LSM that does not
>> meet all of the requirements but that can be supplemented by another
>> LSM that fills the gaps. It allows an LSM like Smack that implements
>> label based access controls to remain true to its purpose even in the
>> face of pressure to add controls based on other mechanisms.
>>
>> I have had requests for running Smack and AppArmor together Tetsuo has
>> long had need to put SELinux and TOMOYO on the same box. Yama was
>> recently special cased for stackability.
> I'd say we need to see the actual use-case for Smack and Apparmor being 
> used together, along with at least one major distro committing to support 
> this.

Or SELinux and TOMOYO. Or AppArmor and TOMOYO.

And before we get too far, distros are no longer the driving force
for Linux development. I suggest that "operating systems", including
ChromiumOS, Android and Tizen are every bit as important. I suggest
that if Android wants to use SELinux and AppArmor those wild and
crazy folks in Mountain View ought to be able to do so.

> Yama is special-cased and can stay that way.

Yama is *not* a special case, it is an example. It is the kind
of new thing that provides security that is not access control.
It was special cased at the request of distros because there was
no general mechanism for including it along with the primary
LSM.

> SELinux and Tomoyo together makes no sense to me, and similarly, I would 
> like to see the specific use-case for it and distro commitment to support 
> it.

I'm not the advocate for that particular combination.
The point is that there are advocates. And distros are not
the only drivers. I agree that some consumer (distro, "OS")
needs to step forward.

>> We are looking at security from different directions than ever before.
>> What good is a UID on a cell phone? I hear complaints about Android's
>> "abuse" of the UID. 
> What is the UID issue and how does LSM stacking address it?

Android utilizes UIDs in a way that has often been referred to as
"hijacking". The UID mechanism supports much of what they want,
but clearly isn't complete. Now that Android is moving to multi-user
support they're hitting conflicts with their use of the UID 
attribute. They really ought to be using an LSM that implements
the security policy they want rather than hacking around the
behavior of UID based controls.

>> With the option of independent groups creating smallish LSMs and 
>> integrating them by stacking we have the ability to make the security 
>> systems modern devices require using a architecturally clean model 
>> rather than hijacking existing mechanisms that work a little bit like 
>> what you want to do.
> This is speculative.

That multiple LSMs provides the tool is not speculation.
That new development would ensue is indeed speculative.
Or at least not yet public.

>> I used to believe in a single, integrated security module that addressed
>> all the issues. Now that Linux is supporting everything from real time
>> tire pressure gauges in tricycles to the global no-fly list that just
>> doesn't seem reasonable. We need better turn around on supplemental 
>> mechanisms. That means collections of smaller, simpler LSMs instead of
>> monoliths that only a few select individuals or organizations have any
>> hope of configuring properly.
> If you're trying to say that only a few select individuals or orgs can 
> configure things like SELinux and AppArmor properly, you're wrong, and the 
> evidence for that is overwhelming.

Disto & OS vendors have the knowledge and tools to do this right.

> Also, are you saying that security mechanisms are inherently easier to 
> configure if they're composed from a variety of distinct modules vs. a 
> monolithic scheme? 

Nope. I'm saying that for specific use cases including but not limited to
telephones, TVs and surveillance networks it is simpler and more appropriate
to create the access control and security schemes that directly address
the needs than to attempt to squeeze them into corsets designed in the
1990's.

And to top it off, Yama has no configuration. It's lots easier to configure.

