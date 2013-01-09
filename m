Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254Ab3AIRHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 12:07:04 -0500
Received: from nm15-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.17]:28921
	"EHLO nm15-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132Ab3AIRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 12:07:00 -0500
X-Yahoo-Newman-Id: 353177.32658.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: prALKeIVM1mCyUNMWyaHIsR7atkl_4FGN4fsJGv8j1Ksdnn
 63tR8GxGKtzfOil2Ylv0.dtjQuraVlBFkBC7Tc2y9PieukNbwVa9ZQnZgjTA
 n.LMfUs0LcRHyIqrU_M9iu.k7hrcrTBJdQcECFBasw82lvAelHx6jMncRpSP
 kxkFflL3eji4sRVKJ076L77FY2O.2.UVBsv8nS6f9jgQoS36oZFIwfx1h4Qw
 csuoc5YGIG6zwlcj8gd2sW3gWsHBLik7OOQju0ram1T3Y77S4mIpFw_H_g9K
 EKSuFK9nGGdC85RGITVBxuhOk2TeH2gplth9G.etDtymlal0VaBpsAlwZVQg
 07iAiRMLSU.1vZPyxZdy3.BditutFqVK2qfcazm6C3V8aNfJwralbTW6U5WQ
 CgJooQ.jKdSzFrMDO9g2_z9gs9rIg6bNRi1zYMfiwYqleT.BoyQRWZIxFqjA
 vAIGx
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDA3C0.8050601@schaufler-ca.com>
Date: Wed, 09 Jan 2013 09:07:12 -0800
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
        Andrew Morton c <akpm@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com> <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org> <50EC53E3.6070606@schaufler-ca.com> <alpine.LRH.2.02.1301100031590.5423@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1301100031590.5423@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2013 5:42 AM, James Morris wrote:
> On Tue, 8 Jan 2013, Casey Schaufler wrote:
>
>> What I was hoping to say, and apparently didn't, is that people
>> are developing "total" solutions in user space, when some of the
>> work ought to be done in an LSM. Work that is appropriate to the
>> kernel is being done in user space. Often badly, because the
>> kernel provides too many mechanisms to circumvent user space
>> based access controls.
> People do stupid things all the time.

No argument there.
But sometimes it's not a matter of doing a stupid thing so much
as doing what is pragmatic with the tools provided.

> How is this particular case our problem to fix?

Well, somebody ought to, and we're the experts.

> Do you have any concrete examples?

ChromiumOS. Android (OK, the binder driver is in the kernel, but it
isn't a proper driver, it should be an LSM). dbus. X11 security
mechanisms in various incarnations dating back to the UNIX days.

All are things that implement their own policies, and all of which
could have reduced exposure if they could depend on access controls
the kernel does not provide.

Those last two paragraphs represent an opinion, by the way.
An informed opinion, but it should not be considered a criticism
of any of those fine systems or system components. 

>> And before we get too far, distros are no longer the driving force
>> for Linux development. I suggest that "operating systems", including
>> ChromiumOS, Android and Tizen are every bit as important. 
> Indeed.  I was including these projects as "distros".
>
>>> What is the UID issue and how does LSM stacking address it?
>> Android utilizes UIDs in a way that has often been referred to as
>> "hijacking". The UID mechanism supports much of what they want,
>> but clearly isn't complete. Now that Android is moving to multi-user
>> support they're hitting conflicts with their use of the UID 
>> attribute. They really ought to be using an LSM that implements
>> the security policy they want rather than hacking around the
>> behavior of UID based controls.
> Right, so they implement an LSM to do what they need.  What does this have 
> to do with stacking?

SELinux has proven to be a useful debugging tool in the Android
environment. If Android implemented their own LSM today they would
no longer be able to use SELinux to help them track down bugs.


>>> Also, are you saying that security mechanisms are inherently easier to 
>>> configure if they're composed from a variety of distinct modules vs. a 
>>> monolithic scheme? 
>> Nope. I'm saying that for specific use cases including but not limited to
>> telephones, TVs and surveillance networks it is simpler and more appropriate
>> to create the access control and security schemes that directly address
>> the needs than to attempt to squeeze them into corsets designed in the
>> 1990's.
> That may be true, but we do need at least one significant user to step up 
> with concrete plans for deployment.

John Johansen has spoken up for Ubuntu.
I suggest that we already have stacking deployed for Yama,
it's just not a general solution.
Kees Cook has another small LSM he'd like to stack as he does Yama.

I don't see that lack of "concrete plans for deployment" is
going to be an issue.

