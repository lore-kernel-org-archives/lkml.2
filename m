Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0HKQBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 12:01:15 -0400
Received: from Mail.MNSU.EDU ([134.29.1.12]:40095 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0HKQBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 12:01:13 -0400
X-Greylist: delayed 875 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Aug 2010 12:01:13 EDT
Message-ID: <4C62C5BD.3020808@mnsu.edu>
Date: Wed, 11 Aug 2010 10:46:05 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@st.com>
CC: Felipe Contreras <felipe.contreras@gmail.com>,
        "git@vger.kernel.org" <git@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Valeo de Vries <valeo@valeo.co.cc>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Matti Aarnio <matti.aarnio@zmailer.org>, mihai.dontu@gmail.com,
        dwmw2@infradead.org, richardcochran@gmail.com,
        "Gadiyar, Anand" <gadiyar@ti.com>
Subject: Re: Query: Patches break with Microsoft exchange server.
References: <4C5F9B25.8080401@st.com> <AANLkTinxwRFLUibJECm0c3_oL5mYRkmscsw-xXgAHSTe@mail.gmail.com> <4C624AE1.30504@st.com>
In-Reply-To: <4C624AE1.30504@st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 02:01 AM, viresh kumar wrote:
 > When i send a mail using git send-email then it receives fine on
 > outlook but on thunderbird, tabs are converted to spaces.
 >
 > This doesn't happen with every patch on thunderbird, but only a few.
 > And observation is that it happens only with big patches.
 > (more than 500 lines)
 >
 > Any idea, how to solve issue now on thunderbird??

Hello,

Exchange 2010 does not handle IMAP "chunking" (partial message transfer) 
correctly.  Any request after about 1 megabyte of total message size 
will fail.

Thunderbird uses this "chunking" feature to give you a status update 
while downloading large messages.  The IMAP statements are of this type:
11 UID fetch 244477 (UID RFC822.SIZE BODY[]<20480.12288>)

When the 20480 is larger than 1MB Exchange "claims" there is no more.  
Sigh....

Fortunately you can disable this feature.  To disable this in 
Thunderbird you can go to the Advanced configuration and disable the 
following feature, by setting it to false:
mail.server.default.fetch_by_chunks


-- 
Jeffrey Hundstad



