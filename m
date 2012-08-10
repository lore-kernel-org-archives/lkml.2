Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2HJHMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 03:12:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754718Ab2HJHMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 03:12:44 -0400
Message-ID: <5024B4A5.9090309@redhat.com>
Date: Fri, 10 Aug 2012 09:13:41 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for 3.6-rc1] media updates part 2
References: <5017F674.80404@redhat.com> <alpine.DEB.2.00.1208081526320.11542@chino.kir.corp.google.com> <5023A11C.50502@redhat.com> <5023A645.40308@redhat.com> <5023AF3A.9050206@redhat.com> <alpine.DEB.2.00.1208091302220.12942@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1208091302220.12942@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/09/2012 10:03 PM, David Rientjes wrote:
> On Thu, 9 Aug 2012, Mauro Carvalho Chehab wrote:
>
>> Yeah, that would work as well, although the code would look uglier.
>> IMHO, using select/depend is better.
>>
>
> Agreed, I think it should be "depends on LEDS_CLASS" rather than select
> it if there is a hard dependency that cannot be fixed with extracting the
> led support in the driver to #ifdef CONFIG_LEDS_CLASS code.

The led support could be #ifdef CONFIG_LEDS_CLASS, the problem with that
approach is the whole module versus build-in thing:

led-class	shark		enable-led-support
build-in	build-in	yes
build-in	module		yes
module		build-in	no
module		module		yes

Now this can be coded into #ifdef magic, but it won't be pretty,
of course we only need the non pretty version once at the top
to set a SHARK_USE_LEDS define, but still.

I'm fine with either solution (depends or ifdef magic), although
I think that people will get unpleasantly surprised if they want
to use the shark driver and they don't get to see it in the
menu because they don't have leds enabled.

Regards,

Hans
