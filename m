Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2A0Gve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:51:34 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:34174 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2A0Gvd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:51:33 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "levinsasha928\@gmail.com" <levinsasha928@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davej\@redhat.com" <davej@redhat.com>,
        "sjurbren\@gmail.com" <sjurbren@gmail.com>
Subject: Re: [PATCH] netns: fix net_alloc_generic()
References: <CA+1xoqe+Qa1OByj7z7XzAPG_g9+BmNj9NPZR=_5b_MTEmc9Chw@mail.gmail.com>
	<1327523631-3480-1-git-send-email-sjur.brandeland@stericsson.com>
	<1327574498.2500.22.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<4F212E7E.2040801@parallels.com>
	<1327575108.2500.24.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<m1zkdacbsx.fsf@fess.ebiederm.org>
	<1327644547.2919.11.camel@edumazet-laptop>
Date: Thu, 26 Jan 2012 22:54:07 -0800
In-Reply-To: <1327644547.2919.11.camel@edumazet-laptop> (Eric Dumazet's
	message of "Fri, 27 Jan 2012 07:09:07 +0100")
Message-ID: <m1k44d8wkw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ERRRH5132F6zj5G1e1Sstapd3rW9Zm58=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> Le jeudi 26 janvier 2012 à 14:57 -0800, Eric W. Biederman a écrit :
>
>> It is not a chicken and egg problem.  It is a bug in caif.
>> caif is claiming to be a network device when it is acting as a subsytem.
>> That means it is being initialized too late.
>> 
>
> Ah ok !
>
>> Untested but this should trivially fix the problem, and a bunch
>> of others of the same ilk.
>> 
>
> Hmm, please refrain from using "trivially" or "trivial", you're not
> fooling anyone.

All I meant is that the change was trivial.

> Truth is this netns layer is horribly complex, since this CAIF bug
> needed no more than four patch attempts and lastly your own work before
> finding the root cause.

As for the complexity I don't know that it is noticeably worse than the
initialization complexity of the network stack in general.

I do think that it is non-obvious that serious initialization ordering
problems can be caused by such a small difference.  The non-locality
and of cause and effect, combined with unfamiliarity of the code seems
to be what hides problems like this.

Once you know that initialization ordering problems tend to registering
the wrong way.  Aka as a device instead of a subsys the solution to
problems like this tend to jump out at you.

Now the common plumbing in net/core/net_namespace.c does count as
complex.  The fact we missed such an obvious optimization opportunity
for so long seems to confirm that.

I am open for ideas on how to simply things.  

Eric
