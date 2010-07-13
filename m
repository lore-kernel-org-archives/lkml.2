Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0GMOTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:19:07 -0400
Received: from anguilla.debian.or.at ([86.59.21.37]:40962 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0GMOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:19:05 -0400
Date: Tue, 13 Jul 2010 16:19:02 +0200
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
Message-ID: <20100713141902.GB15122@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Avi Kivity <avi@redhat.com>, Greg KH <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Glauber Costa <glommer@redhat.com>,
	Zachary Amsden <zamsden@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Marcelo Tosatti <mtosatti@redhat.com>
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C3C68C8.4060409@redhat.com>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Avi Kivity wrote:

>> BUG: unable to handle kernel paging request at ffffffff81712e80
>> IP: [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
>> PGD 1003067 PUD 1007063 PMD 7e8b1063 PTE 8000000001712161
> Read-only pte
>> Oops: 0003 [#2] SMP
> Write fault.
>> Code: 78 4f 44 89 e1 48 d3 e0 44 89 f2 48 f7 e2 48 0f ac d0 20 4a 8d 0c 38 44 39 03 75 a4 48 8b 15 15 df 6b 00 48 39 ca 77 17 48 89 d0<f0>  48 0f b1 0d 04 df 6b 00 48 39 c1 48 89 c2 75 e7 48 89 ca 48
>> RIP  [<ffffffff81054f73>] pvclock_clocksource_read+0x83/0xc0
> --> lock cmpxchg %rcx,0x6bdf04(%rip)


>> static atomic64_t last_value = ATOMIC64_INIT(0);
>>
>> cycle_t pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
>>         last = atomic64_cmpxchg(&last_value, last, ret);


> So it looks like last_value was placed in a read only section.  Please  
> post your System.map somewhere.

weasel@intrepid:~$ publish System.map
http://asteria.noreply.org/~weasel/volatile/2010-07-13-mbm2xEdd8Q4/System.map
weasel@intrepid:~$ grep -i last_value System.map
ffffffff81712e80 r last_value
ffffffff81b05240 b last_value.26163

Cheers,
Peter
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
