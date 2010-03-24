Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0CXV3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 17:29:22 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:60689 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0CXV3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 17:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xGP/33rh0vMmFINfb5rF+z0IiVvfwEXmeClb+z5xRxAyVTfYDVUN14dVjMEgSV9So0
         H98z661CDZ0Po31/tV9lZbFqRTSbZ8RlxgAX5FJQtd94D7JDyqT4O79I+gkjTx1thwcw
         kToQFuS7bGsUTDBdSO4zoo6n8sNXKaiB9tJRE=
Message-ID: <4BAA842A.6060906@gmail.com>
Date: Wed, 24 Mar 2010 22:29:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.9 Thunderbird/3.1b1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC 06/15] PM / Hibernate: swap, remove swap_map_handle usages
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-6-git-send-email-jslaby@suse.cz> <20100324203329.GG5798@elf.ucw.cz>
In-Reply-To: <20100324203329.GG5798@elf.ucw.cz>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 09:33 PM, Pavel Machek wrote:
> On Tue 2010-03-23 17:17:34, Jiri Slaby wrote:
>> Some code, which will be moved out of swap.c, needs know nothing about
>> swap. There will be also other than swap writers later, so that it
>> won't make sense at all.
>>
>> Make it a global static in swap.c as a singleton.
> 
> I guess I just dislike global static. Logically, methods do operate on
> handles, so...

Ok, "upper layers" may get a handle via .get_reader/writer. The downside
is that they would have to get (void *) and pass (void *) down again. I
wanted to avoid that (taking into account that it's a singleton).

> I don't see a point and I do not think the change is an improvement.

The point was to avoid (void *)'s and save users from transferring
pointer as a handle. No matter what, the decision is not up to me,
discussion indeed welcome.

-- 
js
