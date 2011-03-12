Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1CLRBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 12:01:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64111 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1CLRBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 12:01:36 -0500
MIME-Version: 1.0
In-Reply-To: <20110309222629.GB30323@kroah.com>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
	<20110309213813.GA28009@kroah.com>
	<1299708672.17577.42.camel@unknown001a4b0c2895>
	<20110309222629.GB30323@kroah.com>
Date: Sat, 12 Mar 2011 09:01:35 -0800
X-Google-Sender-Auth: d4eS5uxVTuJvlwwlp0hIJqYkZxc
Message-ID: <AANLkTimcv-0e2=B07LohKEc2VpMCKFSrGLc=9dkUef92@mail.gmail.com>
Subject: Re: [PATCH -v2] capabilites: allow the application of capability
 limits to usermode helpers
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, serge.hallyn@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd prefer it if the invoker had both CAP_SETPCAP and CAP_SYS_MODULE
in its pE set.

Also, have you considered an interface for setting the default values
that is something like a "clone mine"? That is, cache the invoker's
cap_inheritable, and cap_bound? (But not cap_permitted and
cap_effective!) This would take care of atomicity and also allow for
potentially including more state when folk find its logically
necessary as the kernel evolves.

Cheers

Andrew

On Wed, Mar 9, 2011 at 2:26 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Mar 09, 2011 at 05:11:12PM -0500, Eric Paris wrote:
>> On Wed, 2011-03-09 at 13:38 -0800, Greg KH wrote:
>> > > When the kernel launches a usermodehelper it will do so with these as
>> > > the bset and pI.
>> >
>> > Shouldn't the caller of these functions be the ones dictating the
>> > capabilities it should be run with?
>>
>> Yes. And no.  It depends what you mean.  The caps of the 'caller' task
>> are irrelevant.  If I run ifconfig ipv6 I need CAP_NET_ADMIN but the
>> upcall needs CAP_SYS_MODULE.  If I plug in a USB drive there is no
>> 'caller' task which makes sense.
>>
>> Now if by 'caller' you mean 'call site' then yes, we could probably
>> launch usermodehelpers with reduced privileged sets.  We know in the
>> code when we are asking to launch modprobe that we are going to need
>> CAP_SYS_MODULE and don't need caps like CAP_SYS_RAWIO and CAP_MAC_ADMIN.
>> We know when we upcall to hotplug we don't really need any priv, since
>> it's another task that is going to do the real work.  So yeah, there
>> might be some value in another patch to address this....
>
> Yes, that is what I was referring to.
>
>> But neither solves the problem of being able to eliminate capabilities
>> from a machine globally.  In olden times we had a global cap-bound but
>> it was dropped in favor of an inheritance from init type mechanism.
>> Since kthreads don't inherit from init we still end up with this patch.
>
> I'm not objecting to the patch, or the idea, just want to make sure it
> is correct.
>
> thanks,
>
> greg k-h
>
