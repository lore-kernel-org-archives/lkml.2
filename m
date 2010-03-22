Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0CVMby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:31:54 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:49607 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0CVMbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uvW5yAWqjWqGLeEcn8nmF8aeKQ6KcTkioyExww1VTfDwX3Sakz0XEDlp8lnMeOp+8K
         ESFh1t+rq295jEuMyjGUu8ZoMF6nsk6pDR1tSeOZXTDk4ErlAsXtbOQuFx9DVNP1xpfS
         iwA+GO7MbTCMzMplGVOrClafBuTuLcM3y9jEI=
MIME-Version: 1.0
In-Reply-To: <20100322114824.GF3483@elte.hu>
References: <20100321191742.GD25922@elte.hu>
	 <20100321200849.GA51323@dspnet.fr.eu.org>
	 <4BA67D75.8060809@redhat.com> <4BA67F12.6030501@nagafix.co.uk>
	 <4BA68063.2050800@redhat.com> <4BA68234.1060804@nagafix.co.uk>
	 <4BA68997.60406@redhat.com> <20100321212009.GE30194@elte.hu>
	 <4BA70F9A.8030304@redhat.com> <20100322114824.GF3483@elte.hu>
Date: Mon, 22 Mar 2010 14:31:49 +0200
X-Google-Sender-Auth: 360c0cb31576dcef
Message-ID: <84144f021003220531p391975f2p5a2e0cfd3a2af6d@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Olivier Galibert <galibert@pobox.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 1:48 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> What about line number information?  And the source?  Into the kernel with
>> them as well?
>
> Sigh. Please read the _very first_ suggestion i made, which solves all that. I
> rarely go into discussions without suggesting technical solutions - i'm not
> interested in flaming, i'm interested in real solutions.
>
> Here it is, repeated for the Nth time:
>
> Allow a guest to (optionally) integrate its VFS namespace with the host side
> as well. An example scheme would be:
>
>   /guests/Fedora-G1/
>   /guests/Fedora-G1/proc/
>   /guests/Fedora-G1/usr/
>   /guests/Fedora-G1/.../
>   /guests/OpenSuse-G2/
>   /guests/OpenSuse-G2/proc/
>   /guests/OpenSuse-G2/usr/
>   /guests/OpenSuse-G2/.../
>
>  ( This feature would be configurable and would be default-off, to maintain
>    the current status quo. )

Heh, funny. That would also solve my number one gripe with
virtualization these days: how to get files in and out of guests
without having to install extra packages on the guest side and
fiddling with mount points on every single guest image I want to play
with.

                        Pekka
