Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab1HZJJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:09:32 -0400
Received: from mail2.vodafone.ie ([213.233.128.44]:2732 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab1HZJJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:09:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAJNhV05tTHi6/2dsb2JhbAAMNqpPAQEFMgFGEAsNCwklDwJGBg0BBwEBwl+GTASYRYtW
Message-ID: <4E5762C7.50909@draigBrady.com>
Date: Fri, 26 Aug 2011 10:09:27 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Neil Horman <nhorman@tuxdriver.com>, Jovi Zhang <bookjovi@gmail.com>,
        dhowells@redhat.com, roland@redhat.com, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com> <4E527684.3020206@draigBrady.com> <20110822161914.GA9399@redhat.com> <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com> <20110824110134.GA17362@hmsreliant.think-freely.org> <20110825155735.GA5380@redhat.com>
In-Reply-To: <20110825155735.GA5380@redhat.com>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 04:57 PM, Oleg Nesterov wrote:
> On 08/24, Neil Horman wrote:
>>
>> The long and the short of it is, making RLIMIT_CORE == 0 for the ispipe case
>> skip the core dump, breaks lots of user space expectations
> 
> Not sure this really makes sense, but perhaps ispipe can skip the dump
> if RLIMIT_CORE == 0 _and_ the signal was sent from the user-space.

I like the sound of that, though don't know the details for
determining signal origin. SIGQUIT generated from a Ctrl-\
from the tty driver might be problematic for example.

cheers,
Pádraig.

