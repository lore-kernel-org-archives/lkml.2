Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab0CVTPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:15:49 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:40081 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328Ab0CVTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:15:48 -0400
Message-ID: <4BA7C1D7.5070208@codemonkey.ws>
Date: Mon, 22 Mar 2010 14:15:35 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu> <4BA7AF2D.7060306@redhat.com>
In-Reply-To: <4BA7AF2D.7060306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 12:55 PM, Avi Kivity wrote:
>> Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by 
>> Anthony.
>> There's numerous ways that this can break:
>
> I don't like it either.  We have libvirt for enumerating guests.

We're stuck in a rut with libvirt and I think a lot of the 
dissatisfaction with qemu is rooted in that.  It's not libvirt that's 
the probably, but the relationship between qemu and libvirt.

We add a feature to qemu and maybe after six month it gets exposed by 
libvirt.  Release time lines of the two projects complicate the 
situation further.  People that write GUIs are limited by libvirt 
because that's what they're told to use and when they need something 
simple, they're presented with first getting that feature implemented in 
qemu, then plumbed through libvirt.

It wouldn't be so bad if libvirt was basically a passthrough interface 
to qemu but it tries to model everything in a generic way which is more 
or less doomed to fail when you're adding lots of new features (as we are).

The list of things that libvirt doesn't support and won't any time soon 
is staggering.

libvirt serves an important purpose, but we need to do a better job in 
qemu with respect to usability.  We can't just punt to libvirt.

Regards,

Anthony Liguori

