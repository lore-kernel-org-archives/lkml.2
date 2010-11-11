Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab0KKKxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 05:53:15 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:51677 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab0KKKxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 05:53:14 -0500
Message-ID: <4CDBCB0E.2020005@euromail.se>
Date: Thu, 11 Nov 2010 11:53:02 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Rafi Rubin <rafi@seas.upenn.edu>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chasedouglas@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Subject: Re: [PATCH] input: Introduce light-weight contact tracking
References: <1289161108-32309-1-git-send-email-rydberg@euromail.se> <4CD724BC.8020702@seas.upenn.edu> <4CD80FCB.20903@euromail.se> <4CD82B28.4060706@seas.upenn.edu> <4CD84A81.3000208@euromail.se> <4CDB7C05.1090306@seas.upenn.edu>
In-Reply-To: <4CDB7C05.1090306@seas.upenn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PGUm8-0001KI-4K.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PGUm8-0001KI-4K 5e738a9cb40c0a1339dd23425884b69b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 06:15 AM, Rafi Rubin wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
>> For every (number of used slots, number of current contacts) pair, two
>> consecutive arrays of values are generated. The first contains the matrix
>> indices corresponding to a certain mapping from contacts to slots. The second
>> contains the actual slot assignment.
>>
>> To find the optimal matching, one simply scans through the appropriate index
>> array, extracting the slot assignment corresponding to the minimum sum of matrix
>> elements. This process is combinatorial and in general scales much worse than
>> for instance the hungarian algorithm, but for small numbers, it can be
>> implemented with very good speed.
> 
> It occurs to me that it might be a good idea to restate our goals and assumptions.


The main goal of my patch is to device a simple, stable, parameter-free matching
function that can be used in interrupt context. If you have such a function,
about a hundred lines of code, completes in a couple of hundred cycles, tested
and benchmarked in the mtdev framework, and which can do six fingers, I would be
happy to use that instead. Otherwise, I suggest we focus on this patch.

> So that's why I selected the approach and data structures I used.  Now if you
> can tell me the studio 17 is going to be the only device that will ever run
> these routines that has more than 4 contacts and is not tracked, then sure,
> screw it.  I have no reason to believe that is a good assumption.


The N-trig device is the only device in the kernel that requires special ghost
filtering. All other devices send reliable data, and either have fewer contacts,
handle their own tracking, or send all data to userspace. Future devices will
most likely have tracking capabilities, and even if they do not, protocol A and
mtdev handles that case. Thus, the question is really whether a new device would
produce unreliable contact data. I find that unlikely.


> Even if we do want to limit the code to 4 contacts, we still need some motion
> estimation, particularly for the lower frame rate devices.


Second-order methods for a device that does not even produce zeroth-order
contact data? As far as I know, the first-order tracking in mtdev has not
disappointed anyone yet, so your statement seems to need elaboration.

Henrik
