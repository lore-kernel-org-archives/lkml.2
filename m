Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab2D1Jd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:33:29 -0400
Received: from mx1.b1-systems.de ([217.11.58.35]:37667 "EHLO mx1.b1-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2D1Jd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:33:28 -0400
Message-ID: <4F9BB87C.4050103@b1-systems.de>
Date: Sat, 28 Apr 2012 11:29:32 +0200
From: Karsten Keil <keil@b1-systems.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>,
        Hansjoerg Lipp <hjlipp@web.de>, i4ldeveloper@listserv.isdn4linux.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] isdn/gigaset: ratelimit CAPI message dumps
References: <20120425-patch-gigaset-00.tilman@imap.cc> <20120425-patch-gigaset-01.tilman@imap.cc> <4F98EDB1.5090702@b1-systems.de> <4F9A7510.5010808@imap.cc>
In-Reply-To: <4F9A7510.5010808@imap.cc>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 27.04.2012 12:29, schrieb Tilman Schmidt:
> Am 26.04.2012 08:39, schrieb Karsten Keil:
>> Am 26.04.2012 01:02, schrieb Tilman Schmidt:
>>> Introduce a global ratelimit for CAPI message dumps to protect
>>>  against possible log flood. Drop the ratelimit for ignored 
>>> messages which is now covered by the global one.
>> 
>> Hmm, I think the only CAPI messages which would need a ratelimit 
>> are related to the DATA_B3 messages. If you need CAPI debug 
>> messages in most cases you do not need all of the DATA_B3, but 
>> you do not want to miss any other message related to the call 
>> control. With a general rate limit you do not have the control, 
>> which messages are logged and which are not.
> 
> The ratelimit introduced by this patch only applies to messages 
> other than DATA_B3. Logging DATA_B3 messages is not done via 
> dump_cmsg().
> 

Thanks for the clarification, forget about my objection.
I ack this patch now.

> I'd like to ratelimit specifically non-DATA_B3 messages because I 
> saw a (possibly buggy) CAPI application flooding the log with 
> FACILITY messages. Equally important, I'd like to make the 
> ratelimit in do_nothing() / do_unsupported() bursty because I had
> a case where I needed to see several ignored/unhandled CAPI
> messages in quick succession. So this patch is killing two birds
> with one stone for me.
> 
> The burst limit of 20 messages in 20 seconds is chosen to allow a 
> complete call setup sequence to be logged, while limiting to one 
> message per second in the long run.
> 
>> And here maybe some cases, when even the DATA_B3 are important 
>> (e.g. searching bugs in flow control), so I would make it still 
>> conditional to allow to print all messages.
> 
> DATA_B3 dumps produce an enormous amount of log data and are 
> therefore controlled separately by the DEBUG_MCMD flag. Someone
> who enables that should know what she or he does. But if you need
> them, you need them all. A ratelimit doesn't make sense there in
> my experience.
> 
>> And I'm not sure, if this is really something for stable.
> 
> It's pretty simple and localized, a net simplification, and only 
> affects generation of debugging messages, so I think it's safe.
> But if you see a problem there I can drop the "CC: stable" line.
> 

I let the decision about it to you and the stable maintainers.

- -- 
Karsten Keil
Linux Kernel Development
Tel: +49 175 7249132
Mail: keil@b1-systems.de

B1 Systems GmbH
Osterfeldstraﬂe 7 / 85088 Vohburg / http://www.b1-systems.de
GF: Ralph Dehner / Unternehmenssitz: Vohburg / AG: Ingolstadt,HRB 3537
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+buHwACgkQo5VVC52CNcRoygCfWwPlWZ+A48OwEkr/MtK6PeNG
0UEAnipdxPSZDKa4s99LlGYwvggWIIAJ
=CLr6
-----END PGP SIGNATURE-----
