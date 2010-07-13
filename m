Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab0GMRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:25:28 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:51639 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0GMRZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:25:27 -0400
Date: Tue, 13 Jul 2010 19:25:26 +0200
From: Peter Palfrader <peter@palfrader.org>
To: Avi Kivity <avi@redhat.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization
	point for pvclock
Message-ID: <20100713172526.GE15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Glauber Costa <glommer@redhat.com>,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com> <20100713141902.GB15122@anguilla.noreply.org> <4C3C8CE5.1080705@redhat.com> <20100713162207.GC15122@anguilla.noreply.org> <4C3C9589.4090602@redhat.com> <4C3C96EC.8060901@redhat.com> <4C3C9839.4090404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C3C9839.4090404@redhat.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Avi Kivity wrote:

> On 07/13/2010 07:40 PM, Avi Kivity wrote:
>> On 07/13/2010 07:34 PM, Avi Kivity wrote:
>>>
>>> My bet is that dropping 'static' will fix it.  We may have the wrong  
>>> constraints on atomic64_cmpxchg64(), so the compiler thinks we never  
>>> change last_value.
>>>
>>
>> The constraints are there, but maybe the toolchain is confused.
>>
>
> No they aren't, as Linus just pointed out.  His patch should fix the  
> problem.

Linus's patch touches __xchg() whereas we're using __cmpxchg() in this
particular case I think.

At least, applying it to my 2.6.32.16 tree didn't help, last_value was
still read-only.  Or I backported it wrong.
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
