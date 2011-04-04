Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab1DDMlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:41:17 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:35123 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab1DDMlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:41:16 -0400
X-Greylist: delayed 1245 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 08:41:15 EDT
Message-ID: <4D99B785.9070602@kernelconcepts.de>
Date: Mon, 04 Apr 2011 14:20:21 +0200
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Jeffrey Brown <jeffbrown@android.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] hid-magicmouse: Increase evdev buffer size
References: <1301691819-2090-1-git-send-email-chase.douglas@canonical.com> <AANLkTim-tN=siA8tJVCzNZHs+oM0hN-N8Ckc+9ynnNpb@mail.gmail.com> <4D975072.1040507@canonical.com>
In-Reply-To: <4D975072.1040507@canonical.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/02/2011 06:36 PM, Chase Douglas wrote:
> On 04/01/2011 07:51 PM, Jeffrey Brown wrote:
>> I've got another change in the works that fixes this problem more
>> systematically.
> 
> That would be great :). I still would like to see this patch added so
> it's released with the 2.6.39 kernel and backported to earlier stable
> releases. I hope that's not a problem.

Wouldn't it make sense to change the buffer logic in the input layer
that in the case of a buffer overrun the head gets pushed forward to the
next SYN_REPORT?

One symptom I witnessed with the bug was, that I got partial reports,
which especially in the case of a multitouch report (A-Type) creates
false release-events. This would be solved by the head-forwarding.

(one could even think about more fancy stuff like combining relative
events and keeping track of the absolute events, but this seems a bit
like overkill)

Thanks,
        Simon
- -- 
       Simon Budig                        kernel concepts GbR
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2Zt4UACgkQO2O/RXesiHByIgCgmHsujFhsYcM0wp7qEl+HytNh
wSMAoLygXVkU1Lx+jNgBA++H8OL6dNVR
=9+3z
-----END PGP SIGNATURE-----
