Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab1IGVUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:20:40 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65316 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab1IGVUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:20:37 -0400
Message-ID: <4E67E030.1020702@gmail.com>
Date: Wed, 07 Sep 2011 23:20:48 +0200
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Steve Grubb <sgrubb@redhat.com>
CC: "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Neil Horman <nhorman@redhat.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <4E67B75B.8010500@redhat.com> <20110907192737.GD20571@thunk.org> <201109071602.24519.sgrubb@redhat.com>
In-Reply-To: <201109071602.24519.sgrubb@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 10:02 PM, Steve Grubb wrote:

> When a system is underattack, do you really want to be using a PRNG
> for anything like seeding openssl? Because a PRNG is what urandom
> degrades into when its attacked.

Using a PRNG is not a problem. Making sure it is well seeded and no
input from the attacker can compromise its state are the difficult
parts. Making predictable estimates and blocking when your estimates are
off, makes it a good target for DoS. When your system is under attack,
you want to use your services. If they block then the attack might
have just been successful.

regards,
Nikos
