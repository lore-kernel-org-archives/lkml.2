Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1DVVcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:32:55 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:35359 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756572Ab1DVVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:32:53 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: chiQjOEVM1lRj0hoccfnE.f7YB84z0EvAenkgtHjcpsaEBv
 KvUH1FwWaxlsNEjpc3T2OfknS2Jr.pQQVCbqhIToMurhRaKM7fdXDjZgZk4P
 b7W8NehYVRibdFz9EKMLd.Tlm.w5dCgO1knKsjPbERM6cTnKQg13fBeRY_8Q
 30fHNeVdN9NZdauYSaJOazRnFdssgv7o.UCyMtuwExefRHwklhKdXi6AVPwV
 Xvpe0OGG2BCvVLMw8vONIhh9.w1BeOVV.iyNnrb9aEOAbRLhjACnq9kfZoHh
 05eEnF2MD7CK2DkdjcjGlzwhtIdFDcsekXap30jpU87hoqYTqKURNfF8HLob
 iXERVqMMo2a6pFEoS8joYyRYNdTPPWtuueQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DB1F404.1060504@schaufler-ca.com>
Date: Fri, 22 Apr 2011 14:32:52 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Make RCU dcache work with CONFIG_SECURITY=y
References: <1303431801-10540-1-git-send-email-andi@firstfloor.org> <BANLkTi=kod0vH3Ybb4Fe=Sa5zvzYSmoj1Q@mail.gmail.com> <20110422211649.GW16484@one.firstfloor.org>
In-Reply-To: <20110422211649.GW16484@one.firstfloor.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/2011 2:16 PM, Andi Kleen wrote:
> On Fri, Apr 22, 2011 at 11:26:09AM -0700, Linus Torvalds wrote:
>> On Thu, Apr 21, 2011 at 5:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> I didn't find good test suites for the security modules, so
>>> there wasn't a lot of testing on this unfortunately
>>> (the selinux one for LTP doesn't seem to work). Some close
>>> review of these changes is needed.
>>>
>>> On the other hand the VFS changes itself are very straight forward
>>> and the 1/1 patch is very straight forward (and a win in itself)
>>>
>>> The bottom line is with this patchkit a CONFIG_SECURITY=y
>>> kernel has as good VFS performance as a kernel with CONFIG_SECURITY
>>> disabled.
>> Gaah. My immediate reaction to the patch-series was "This is great, I
>> was really hoping we could get all those annoying cases sorted out,
>> and I'll queue them for the next merge window".
>>
>> Having then actually read through the patches a bit more, I then got
>> convinced that at least the first patch should probably be applied
>> right away and be marked for stable, since it looks pretty damn
>> obvious to me, and it might already on its own fix the performance
>> regression for some configurations (although realistically I guess few
>> enough people really do the "selinux=0" thing, so the big advantage is
>> making easier to backport the other patches later if we don't do them
>> now).
> Yes I agree. The first patch is (nearly) a no-brainer and already
> has significant benefits. I would like to see it in .39.
>
>> Comments? I'd really like to see/hear feedback like "yeah, this looks
>> really obviously safe" vs "yeah, looks good, but I really don't feel
>> very comfortable with it" from the security people.
> Especially SMACK review is needed.

I am happy to get all the help I can on this. I am not now
nor have I ever been especially comfortable with sophisticated
locking models. Where possible I have written code with minimal
locking requirements, but sometimes you just can't avoid it. I
have been fortunate in that several people have offered advice
in the past.

> Or maybe selinux only for now,
> already got one ack for that.
>
> (BTW I have some doubts on the locking in smack in general, 
> but that's a separate issue -- see other thread)
>
> -Andi
>

